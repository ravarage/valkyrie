package main

import (
	"backend/internal/context"
	"backend/internal/router"
	"backend/internal/server"
	"backend/internal/services"
)

func main() {
	c := context.NewContext()
	userRepo := services.NewRoles(c.Queries)
	userService := services.NewService(userRepo, c)
	r := router.Start(c)
	server.Start(r, c)
}
