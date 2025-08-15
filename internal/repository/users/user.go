package users

import (
	"backend/internal/db"
	"backend/internal/parameter"
	"context"
)

type Users struct {
	q *db.Queries
}

func ProvideUsersService(q *db.Queries) *Users {
	return &Users{q}
}

func (r *Users) Create(p parameter.Parameter, E *db.User) error {
	_, err := r.q.CreateUser(context.Background(), db.CreateUserParams{
		Username: E.Username,
		Password: E.Password,
		Email:    E.Email,
		RoleID:   E.RoleID,
		Status:   E.Status,
	})
	return err
}

func (r *Users) Update(p parameter.Parameter, E *db.User, B *db.User) error {
	_, err := r.q.UpdateUser(context.Background(), db.UpdateUserParams{
		ID:       E.ID,
		Username: E.Username,
		Password: E.Password,
		Email:    E.Email,
		RoleID:   E.RoleID,
		Status:   E.Status,
	})
	return err
}

func (r *Users) List(p parameter.Parameter) ([]db.User, error) {
	rows, err := r.q.ListUsers(context.Background())
	if err != nil {
		return nil, err
	}
	out := make([]db.User, 0, len(rows))
	for _, it := range rows {
		if it != nil {
			out = append(out, *it)
		}
	}
	return out, nil
}

func (r *Users) Delete(p parameter.Parameter) error {
	return r.q.DeleteUser(context.Background(), int32(p.ID))
}

func (r *Users) FindAll(p parameter.Parameter) ([]db.User, error) {
	return r.List(p)
}

func (r *Users) GetByID(p parameter.Parameter) (db.User, error) {
	res, err := r.q.GetUser(context.Background(), int32(p.ID))
	if err != nil {
		return db.User{}, err
	}
	return *res, nil
}
