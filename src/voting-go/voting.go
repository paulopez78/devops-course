package main

import (
	"net/http"

	"github.com/labstack/echo"
)

func main() {
	votes := make(map[string]int)
	votes[".netcore"] = 1
	votes["golang"] = 2

	e := echo.New()
	e.GET("/vote", func(c echo.Context) error {
		return c.JSON(http.StatusOK, votes)
	})

	e.POST("/vote", func(c echo.Context) error {
		m := echo.Map{}
		if err := c.Bind(&m); err != nil {
			return err
		}
		return c.JSON(http.StatusOK, m)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
