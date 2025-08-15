package env

type Env struct {
	Server
	Database
	Redis
	JWTToken
}

type Server struct {
	Development    bool   `json:"development" env:"SERVER_DEVELOPMENT"`
	Address        string `json:"address" env:"SERVER_ADDRESS" `
	Port           int    `json:"port" env:"SERVER_PORT" envDefault:"8080"`
	CertFile       string `json:"cert_file" env:"SERVER_CERT_FILE"`
	KeyFile        string `json:"key_file" env:"SERVER_KEY_FILE"`
	UDPReadBuffer  int    `json:"udp_read_buffer" env:"UDP_READ_BUFFER"`
	UDPWriteBuffer int    `json:"udp_write_buffer" env:"UDP_WRITE_BUFFER"`
	AllowedOrigins string `json:"allowed_origins" env:"CORS_ALLOWED_ORIGINS" envDefault:"http://localhost:3000,https://localhost:3000,https://127.0.0.1:8080"`
}

type Database struct {
	DSN string `json:"dsn" env:"DATABASE_DSN"`
}
type Redis struct {
	Host     string `json:"host" env:"REDIS_HOST"`
	DB       int    `json:"db" env:"REDIS_DB"`
	Password string `json:"password" env:"REDIS_PASSWORD"`
}

type JWTToken struct {
	RefreshSecret string `json:"refresh_secret" env:"JWT_REFRESH_SECRET"`
	AccessSecret  string `json:"access_secret" env:"JWT_ACCESS_SECRET"`

	RefreshAge int64 `json:"refresh_age" env:"JWT_REFRESH_AGE,required"`
	AccessAge  int64 `json:"access_age" env:"JWT_ACCESS_AGE,required"`
}
