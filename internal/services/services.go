package services

import (
	"backend/internal/context"
	"backend/internal/interfaces"
	"backend/internal/parameter"
)

type Service[T any] struct {
	repo interfaces.Service[T]
	Ctx  *context.Context
}

func NewService[T any](repo interfaces.Service[T], ctx *context.Context) *Service[T] {
	return &Service[T]{repo: repo, Ctx: ctx}
}

func (s *Service[T]) GetByID(p parameter.Parameter) (data T, err error) {
	key, _ := p.GenCachKey()
	// Try cache first
	if err = s.Ctx.Get(key, &data); err == nil {
		return data, nil
	}
	// Cache miss: fetch from repo
	data, err = s.repo.GetByID(p)
	if err != nil {
		return data, err
	}
	_ = s.Ctx.Set(key, data, 60)
	return data, nil
}

func (s *Service[T]) Create(p parameter.Parameter, e *T) error {
	return s.repo.Create(p, e)
}

func (s *Service[T]) Update(p parameter.Parameter, e *T, b *T) error {
	return s.repo.Update(p, e, b)
}

func (s *Service[T]) List(p parameter.Parameter) (data []T, err error) {
	key, _ := p.GenCachKey()
	// Try cache first
	if err = s.Ctx.Get(key, &data); err == nil {
		return data, nil
	}
	// Cache miss
	data, err = s.repo.List(p)
	if err != nil {
		return nil, err
	}
	_ = s.Ctx.Set(key, data, 60)
	return data, nil
}

func (s *Service[T]) Delete(p parameter.Parameter) error {
	return s.repo.Delete(p)
}

func (s *Service[T]) FindAll(p parameter.Parameter) ([]T, error) {
	return s.repo.FindAll(p)
}
