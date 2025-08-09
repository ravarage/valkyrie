package services

import (
	"backend/internal/db"
	"backend/internal/parameter"

	"golang.org/x/net/context"
)

type Roles struct {
	q *db.Queries
}

func NewRoles(q *db.Queries) *Roles {
	return &Roles{q: q}
}
func (r *Roles) GetByID(p parameter.Parameter) (*db.Role, error) {
	return r.q.GetRole(context.Background(), int32(p.ID))
}
