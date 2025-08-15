package services

import (
	"backend/internal/context"
	"backend/internal/db"
	"backend/internal/interfaces"
	"backend/internal/repository/users"
)

type UserService struct {
	*Service[db.User]
}

// NewUserService constructs a user service backed by the given repo and context.
func NewUserService(ctx *context.Context) *UserService {
	var repo interfaces.Service[db.User]
	repo = users.ProvideUsersService(ctx.Queries)

	return &UserService{
		Service: NewService[db.User](repo, ctx),
	}
}
