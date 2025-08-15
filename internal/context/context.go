package context

import (
	"backend/internal/db"
	"backend/internal/env"
	"backend/internal/tools/authtools"
	"log"

	envParser "github.com/caarlos0/env/v11"
	"github.com/jackc/pgx/v5"
	"github.com/redis/go-redis/v9"
	"golang.org/x/net/context"
)

type Context struct {
	context.Context
	Environments env.Env
	Queries      *db.Queries
	DB           *pgx.Conn
	RDB          *redis.Client
	RefreshToken *authtools.JWTTools
	AccessToken  *authtools.JWTTools
}

func NewContext() *Context {
	var Environments env.Env

	if err := envParser.Parse(&Environments); err != nil {
		log.Fatalln(err)
	}
	ctx := context.Background()

	conn, err := pgx.Connect(ctx, Environments.Database.DSN)
	if err != nil {
		log.Fatalln(err)
	}
	rdb := redis.NewClient(&redis.Options{
		Addr:     Environments.Redis.Host,
		Password: Environments.Redis.Password, // no password set
		DB:       Environments.Redis.DB,       // use default DB
	})
	_, err = rdb.Ping(ctx).Result()
	if err != nil {
		log.Fatalln(err)
	}

	// Do not close the DB connection here; keep it alive for the application's lifetime.
	queries := db.New(conn)

	accessToken := authtools.ProvideJWTTools(Environments.JWTToken.AccessSecret, Environments.JWTToken.AccessAge)
	RefreshToken := authtools.ProvideJWTTools(Environments.JWTToken.RefreshSecret, Environments.JWTToken.RefreshAge)

	return &Context{Environments: Environments, Queries: queries, DB: conn, RDB: rdb, RefreshToken: RefreshToken, AccessToken: accessToken}
}
