package errorlogger

import (
	"net/http"
)

const (
	Notfound = iota
	Forbidden
	NotAuthorized
	InternalError
	BadRequest
	Conflict
)

var HttpError = map[int]int{
	Notfound:      http.StatusNotFound,
	Forbidden:     http.StatusForbidden,
	NotAuthorized: http.StatusUnauthorized,
	InternalError: http.StatusInternalServerError,
	BadRequest:    http.StatusBadRequest,
	Conflict:      http.StatusConflict,
}

var GrpcError = map[int]int{
	Notfound:      1,
	Forbidden:     2,
	NotAuthorized: 3,
	InternalError: 4,
	BadRequest:    5,
	Conflict:      6,
}
