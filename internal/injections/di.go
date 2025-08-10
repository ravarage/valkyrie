//go:generate go tool kessoku $GOFILE
package di

import (
	"backend/internal/db"
	"backend/internal/handlers"
	"backend/internal/interfaces"
	"backend/internal/repository/roles"
	"backend/internal/services"

	"github.com/mazrean/kessoku"
)

// Use a concrete alias to help the generator keep the instantiated generic type
// This prevents generated files from dropping the type argument.
type RoleSvc = interfaces.Service[db.Role]

var _ = kessoku.Inject[*handlers.RoleHandler](
	"RoleAPIWithInterface",
	kessoku.Async(kessoku.Provide(roles.ProvideRolesService)),
	kessoku.Provide(services.NewRoleService),
	kessoku.Provide(handlers.NewRoleHandler),
)
