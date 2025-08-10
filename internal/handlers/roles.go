package handlers

import (
	"backend/internal/context"
	"backend/internal/parameter"
	"backend/internal/services"
	"fmt"
	"strconv"

	"github.com/labstack/echo/v4"
)

type RoleHandler struct {
	service *services.RoleService
	Ctx     *context.Context
	Entity  string
}

func NewRoleHandler(ctx *context.Context) *RoleHandler {

	return &RoleHandler{service: services.NewRoleService(ctx), Ctx: ctx, Entity: "roles"}
}

func (h *RoleHandler) GetRoleByID(c echo.Context) error {

	parameters, _ := parameter.GetParams(c, h.Ctx, h.Entity)

	idStr := c.Param("id")
	if idStr == "" {
		return c.JSON(400, echo.Map{"error": "id parameter is required"})
	}
	id, err := strconv.ParseInt(idStr, 10, 64)
	if err != nil {
		return c.JSON(400, echo.Map{"error": "invalid id"})
	}
	parameters.ID = id
	fmt.Println(parameters)
	role, err := h.service.GetByID(parameters)
	if err != nil {
		fmt.Println(err)
		return c.JSON(500, echo.Map{"error": err.Error()})
	}
	return c.JSON(200, role)
}
