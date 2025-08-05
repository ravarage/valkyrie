package env

type Env struct {
	Server
}

type Server struct {
	Development    bool   `json:"development" env:"SERVER_DEVELOPMENT"`
	Address        string `json:"address" env:"SERVER_ADDRESS"`
	Port           int    `json:"port" env:"SERVER_PORT"`
	CertFile       string `json:"cert_file" env:"SERVER_CERT_FILE"`
	KeyFile        string `json:"key_file" env:"SERVER_KEY_FILE"`
	UDPReadBuffer  int    `json:"udp_read_buffer" env:"UDP_READ_BUFFER"`
	UDPWriteBuffer int    `json:"udp_write_buffer" env:"UDP_WRITE_BUFFER"`
	AllowedOrigins string `json:"allowed_origins" env:"CORS_ALLOWED_ORIGINS" envDefault:"http://localhost:3000,https://localhost:3000,https://127.0.0.1:8080"`
}
