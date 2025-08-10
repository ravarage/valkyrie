package roles

import (
	"backend/internal/db"
	"backend/internal/parameter"
	"context"
)

type Roles struct {
	q *db.Queries
}

func ProvideRolesService(q *db.Queries) *Roles {
	return &Roles{q}
}

func (r *Roles) Create(p parameter.Parameter, E *db.Role) error {
	_, err := r.q.CreateRole(context.Background(), db.CreateRoleParams{
		Name:        E.Name,
		Description: E.Description,
		Permissions: E.Permissions,
	})
	return err
}

func (r *Roles) Update(p parameter.Parameter, E *db.Role, B *db.Role) error {
	_, err := r.q.UpdateRole(context.Background(), db.UpdateRoleParams{
		ID:          E.ID,
		Name:        E.Name,
		Description: E.Description,
		Permissions: E.Permissions,
	})
	return err
}

func (r *Roles) List(p parameter.Parameter) ([]db.Role, error) {
	rows, err := r.q.ListRoles(context.Background())
	if err != nil {
		return nil, err
	}
	out := make([]db.Role, 0, len(rows))
	for _, it := range rows {
		if it != nil {
			out = append(out, *it)
		}
	}
	return out, nil
}

func (r *Roles) Delete(p parameter.Parameter) error {
	return r.q.DeleteRole(context.Background(), int32(p.ID))
}

func (r *Roles) FindAll(p parameter.Parameter) ([]db.Role, error) {
	return r.List(p)
}

func (r *Roles) GetByID(p parameter.Parameter) (db.Role, error) {
	res, err := r.q.GetRole(context.Background(), int32(p.ID))
	if err != nil {
		return db.Role{}, err
	}
	return *res, nil
}
