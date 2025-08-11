package authtools

import "github.com/labstack/echo/v4"

type JWTTools struct {
	Secret string
}

func (j *JWTTools) Auth(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		autheratization := c.Request().Header.Get("Authorization")
		if autheratization == "" || len(autheratization) < 7 {
			return c.JSON(401, echo.Map{"error": "Unauthorized"})
		}
		token := autheratization[7:]
		ParseJWT(token)
		return next(c)
	}
}
