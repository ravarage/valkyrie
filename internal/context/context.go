package context

import (
	"backend/internal/env"
	envParser "github.com/caarlos0/env/v11"
	"golang.org/x/net/context"
	"log"
)

type Context struct {
	context.Context
	Environments env.Env
}

func NewContext() *Context {
	var Environments env.Env

	if err := envParser.Parse(&Environments); err != nil {
		log.Fatalln(err)
	}

	return &Context{Environments: Environments}
}
