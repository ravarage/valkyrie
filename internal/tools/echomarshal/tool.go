package echomarshal

import (
	"github.com/goccy/go-json"
	"github.com/labstack/echo/v4"
	"io"
	"net/http"
)

type EchoBinder struct{}

// Bind method overrides the default Echo binder for JSON with goccy/go-json
func (cb *EchoBinder) Bind(i interface{}, c echo.Context) error {
	req := c.Request()
	ctype := req.Header.Get(echo.HeaderContentType)
	if echo.MIMEApplicationJSON == ctype {
		defer req.Body.Close()
		dec := json.NewDecoder(req.Body)
		if err := dec.Decode(i); err != nil && err != io.EOF {
			return echo.NewHTTPError(http.StatusBadRequest, err.Error()).SetInternal(err)
		}
		return nil
	}
	// Use a pointer to the default binder
	return (&echo.DefaultBinder{}).Bind(i, c)
}
