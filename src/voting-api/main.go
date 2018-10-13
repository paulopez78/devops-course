package main

import (
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {

	e := echo.New()

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{echo.GET, echo.HEAD, echo.PUT, echo.PATCH, echo.POST, echo.DELETE},
	}))

	api := "/vote"
	e.GET(api, GetVotes)
	e.POST(api, StartVoting)
	e.PUT(api, Vote)
	e.DELETE(api, FinishVoting)
	e.GET("/ws", StartWebSocket)

	e.Logger.Fatal(e.Start(":8081"))
}
