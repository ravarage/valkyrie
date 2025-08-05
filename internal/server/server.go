package server

import (
	"backend/internal/context"
	"crypto/tls"
	"fmt"
	"github.com/labstack/echo/v4"
	"github.com/quic-go/quic-go"
	"github.com/quic-go/quic-go/http3"
	"log"
	"net"
	"net/http"
	"os"
	"sync"
)

func Start(router *echo.Echo, c *context.Context) {
	tlsConf := generateTLSConfig(c)
	if c.Environments.Development {
		tlsConf.KeyLogWriter = os.Stdout
	}

	quicConf := &quic.Config{Allow0RTT: true}

	h3 := http3.Server{Handler: router}
	h1and2 := http.Server{
		Addr: fmt.Sprintf("%s:%v", c.Environments.Server.Address, c.Environments.Server.Port),
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			if err := h3.SetQUICHeaders(w.Header()); err != nil {
				http.Error(w, "Internal Server Error", http.StatusInternalServerError)
				return
			}
			router.ServeHTTP(w, r)
		}),
		TLSConfig: tlsConf,
	}

	var wg sync.WaitGroup
	wg.Add(2)

	go func() {
		defer wg.Done()
		log.Printf("Starting HTTP/3 router on %s (UDP)", fmt.Sprintf("%s:%v", c.Environments.Server.Address, c.Environments.Server.Port))
		if err := serveHTTP3(&h3, quicConf, c); err != nil {
			log.Fatalf("Failed to serve HTTP/3: %v", err)
		}
	}()

	go func() {
		defer wg.Done()
		log.Printf("Starting HTTP/1.1 and HTTP/2 router on %s", fmt.Sprintf("%s:%v", c.Environments.Server.Address, c.Environments.Server.Port))
		if err := h1and2.ListenAndServeTLS(c.Environments.CertFile, c.Environments.KeyFile); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Failed to serve HTTP/1.1 and HTTP/2: %v", err)
		}
	}()

	wg.Wait()
}

func serveHTTP3(h3 *http3.Server, quicConf *quic.Config, c *context.Context) error {
	addr, err := net.ResolveUDPAddr("udp", fmt.Sprintf("%v:%v", c.Environments.Server.Address, c.Environments.Server.Port))
	if err != nil {
		return fmt.Errorf("failed to resolve UDP address: %w", err)
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		return fmt.Errorf("failed to listen on UDP address: %w", err)
	}
	defer func() {
		if closeErr := conn.Close(); closeErr != nil {
			log.Printf("Error closing UDP connection: %v", closeErr)
		}
	}()

	// Use configured UDP buffer sizes or default to 8MB if not specified
	readBufferSize := c.Environments.Server.UDPReadBuffer
	if readBufferSize <= 0 {
		readBufferSize = 8388608 // 8MB default
	}

	writeBufferSize := c.Environments.Server.UDPWriteBuffer
	if writeBufferSize <= 0 {
		writeBufferSize = 8388608 // 8MB default
	}

	if err := conn.SetReadBuffer(readBufferSize); err != nil {
		log.Printf("Failed to set read buffer to %d bytes: %v", readBufferSize, err)
	} else {
		log.Printf("Successfully set UDP read buffer size to %d bytes", readBufferSize)
	}

	if err := conn.SetWriteBuffer(writeBufferSize); err != nil {
		log.Printf("Failed to set write buffer to %d bytes: %v", writeBufferSize, err)
	} else {
		log.Printf("Successfully set UDP write buffer size to %d bytes", writeBufferSize)
	}

	tr := quic.Transport{Conn: conn}
	ln, err := tr.ListenEarly(generateTLSConfig(c), quicConf)
	if err != nil {
		return fmt.Errorf("failed to create QUIC listener: %w", err)
	}

	return h3.ServeListener(ln)
}
func generateTLSConfig(c *context.Context) *tls.Config {
	certPEM, err := os.ReadFile(c.Environments.CertFile) // use bundle.crt
	fmt.Println(c.Environments.CertFile)
	if err != nil {
		log.Fatalf("Failed to read certificate: %v", err)
	}

	keyPEM, err := os.ReadFile(c.Environments.KeyFile)
	if err != nil {
		log.Fatalf("Failed to read key: %v", err)
	}

	cert, err := tls.X509KeyPair(certPEM, keyPEM)
	if err != nil {
		log.Fatalf("Failed to parse certificate: %v", err)
	}

	config := &tls.Config{
		Certificates: []tls.Certificate{cert},
		ClientAuth:   tls.NoClientCert,
		//ClientCAs:    helper.LoadClientCAPool(engine),
		NextProtos: []string{"h3", "h2", "http/1.1"},
		MinVersion: tls.VersionTLS13,
		CurvePreferences: []tls.CurveID{
			tls.X25519,
			tls.CurveP256,
			tls.CurveP384,
		},
	}

	if c.Environments.Development {
		config.InsecureSkipVerify = true // ⛔ Use only for testing!
	}

	return config
}
