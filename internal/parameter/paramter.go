package parameter

import (
	"backend/internal/context"
	"fmt"

	"github.com/labstack/echo/v4"
)

type Parameter struct {
	ID       int64  `json:"id"`
	Username string `json:"username"`
	Search   string `json:"search"`
	Values   []any  `json:"values"`
	Entity   string `json:"entity"`
	Ctx      *context.Context
	Limit    int `json:"limit"`
	Offset   int `json:"offset"`
}

func GetParams(c echo.Context, ctx *context.Context, Entity string) (param Parameter, err error) {
	param = Parameter{}
	param.Ctx = ctx
	if c.Get("useername") != nil {
		param.Username = c.Get("useername").(string)
	}
	param.Entity = Entity
	return
}

func (p *Parameter) GenCachKey() (key, count string) {
	key = fmt.Sprintf("%s_%d_%s_%d_%d", p.Entity, p.ID, p.Search, p.Limit, p.Offset)
	for _, value := range p.Values {
		key = key + fmt.Sprintf("%v", value)
	}
	count = fmt.Sprintf("%s_count", key)
	return
}
