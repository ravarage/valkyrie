package response

type Response struct {
	Body     any
	RestCode int
	GrpcCode int
	Error    error
}
