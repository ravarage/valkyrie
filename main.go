package main

import (
	"backend/internal/context"
	"backend/internal/router"
	"backend/internal/server"
)

func main() {
	c := context.NewContext()
	r := router.Start(c)
	server.Start(r, c)
}
