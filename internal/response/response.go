package response

import (
	"backend/internal/context"
	"backend/internal/parameter"
	"backend/internal/tools/errorlogger"

	"github.com/goccy/go-json"
	"github.com/labstack/echo/v4"
)

type Response struct {
	Body     any
	RestCode int
	GrpcCode int
	Message  string
	Errors   *errorlogger.AppError
	CTX      *context.Context
}

func NewResponse(c echo.Context, ctx *context.Context, Entity string) (response *Response, param parameter.Parameter, err error) {
	param, err = parameter.GetParams(c, ctx, Entity)
	return &Response{
		CTX: ctx,
	}, param, err
}

func (r *Response) Error(err *errorlogger.AppError) *Response {
	r.Errors = err
	return r
}

func (r *Response) Success(body any) *Response {
	r.Body = body
	return r
}

func (r *Response) JSON() []byte {
	if r.Errors != nil {
		errorresp, err := json.Marshal(r.Errors)
		if err != nil {

		}
		return errorresp
	}
	resp, err := json.Marshal(r.Body)
	if err != nil {

	}
	return resp
}
