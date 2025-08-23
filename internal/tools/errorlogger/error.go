package errorlogger

import "backend/internal/context"

type AppError struct {
	Code     int    `json:"code"`
	Message  string `json:"message"`
	Details  string `json:"details,omitempty"`
	HttpCode int    `json:"http_code"`
	GrpcCode int    `json:"grpc_code"`
}

type ErrorLogger struct {
	Entity  string
	Context context.Context
}

func NewErrorLogger(ctx *context.Context, entity string) *ErrorLogger {
	return &ErrorLogger{Entity: entity, Context: *ctx}
}

func (h *ErrorLogger) LogError(errortype int, err error, message string) *AppError {
	if err == nil {
		return nil
	}
	return &AppError{
		Code:     errortype,
		Message:  message,
		Details:  err.Error(),
		HttpCode: HttpError[errortype],
		GrpcCode: GrpcError[errortype],
	}

}
