package services

import (
	"backend/internal/context"
	"backend/internal/db"
	"backend/internal/interfaces"
	"backend/internal/repository/roles"
)

type RoleService struct {
	*Service[db.Role]
}

// NewRoleService constructs a role service backed by the given repo and context.
func NewRoleService(ctx *context.Context) *RoleService {
	var repo interfaces.Service[db.Role]
	repo = roles.ProvideRolesService(ctx.Queries) // This should implement interfaces.Service[db.Role]

	return &RoleService{
		Service: NewService[db.Role](repo, ctx),
	}
}
