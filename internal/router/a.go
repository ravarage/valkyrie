package router

import (
	"backend/internal/context"
	"backend/internal/tools/echomarshal"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"net/http"
	"strings"
	"time"
)

func Start(engine *context.Context) (e *echo.Echo) {

	e = echo.New()

	// TODO to be check [mos] [Default/New]
	// Set Echo mode based on environment
	if engine.Environments.Development {
		e.Debug = true
		e.Logger.SetLevel(1) // Debug level
		e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
			Format: "method=${method}, uri=${uri}, status=${status}, latency=${latency_human}\n",
		}))
	} else {
		e.Debug = false
		e.Logger.SetLevel(0) // Default level
	}
	e.Binder = &echomarshal.EchoBinder{}
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins:     strings.Split(engine.Environments.AllowedOrigins, ","), // Allow requests only from this origin
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Content-Type", "Authorization", "X-Requested-With", "Accept", "Origin", "User-Agent", "X-Token", "Bearer", "Lang", "Access-Control-Allow-Origin"},
		ExposeHeaders:    []string{"Content-Length", "Content-Type"},
		AllowCredentials: true,                // Allow credentials (cookies, authorization headers)
		MaxAge:           int(12 * time.Hour), // Cache preflight response
	}))

	notFoundRoute(e, engine)

	rg := e.Group("/api/neofinity/v1")
	{
		Route(*rg, engine)
		//Route_ws(*rg, engine)
	}

	return e
}

func notFoundRoute(e *echo.Echo, c *context.Context) {
	e.HTTPErrorHandler = func(err error, c echo.Context) {
		if c.Response().Committed {
			return
		}
		c.Response().Header().Set(echo.HeaderContentType, echo.MIMEApplicationJSONCharsetUTF8)
		c.Response().WriteHeader(http.StatusNotFound)

	}
}
