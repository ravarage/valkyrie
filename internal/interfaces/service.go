package interfaces

import "backend/internal/parameter"

type Service[T any] interface {
	GetByID(parameter parameter.Parameter) (T, error)
	Create(parameter parameter.Parameter, E *T) error
	Update(parameter parameter.Parameter, E *T, B *T) error
	List(parameter parameter.Parameter) ([]T, error)
	Delete(parameter parameter.Parameter) error
	FindAll(parameter parameter.Parameter) ([]T, error)
}
