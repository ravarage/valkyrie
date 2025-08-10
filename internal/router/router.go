package router

import (
	"backend/internal/context"
	di "backend/internal/injections"

	"github.com/labstack/echo/v4"
)

func Route(rg echo.Group, engine *context.Context) {
	// Manually wire roles GET by id endpoint
	roleapi := di.RoleAPIWithInterface(engine)

	rg.GET("/roles/:id", roleapi.GetRoleByID)
}
