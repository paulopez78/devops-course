package main

import (
	"net/http"

	"github.com/labstack/echo"
)

type VotingOptions struct {
	Topics []string `json:"topics"`
}

type Vote struct {
	Topic string `json:"topic"`
}

func main() {
	votes := make(map[string]int)

	e := echo.New()
	e.GET("/vote", func(c echo.Context) error {
		return c.JSON(http.StatusOK, votes)
	})

	e.POST("/vote", func(c echo.Context) error {
		topics := new(VotingOptions)
		if err := c.Bind(topics); err != nil {
			return err
		}

		for _, val := range topics.Topics {
			votes[val] = 0
		}

		return c.JSON(http.StatusOK, votes)
	})

	e.PUT("/vote", func(c echo.Context) error {
		topic := new(Vote)
		if err := c.Bind(&topic); err != nil {
			return err
		}
		votes[topic.Topic]++
		return c.JSON(http.StatusOK, votes)
	})

	e.DELETE("/vote", func(c echo.Context) error {
		var winner string
		for topic := range votes {
			winner = topic
			break
		}
		for topic, count := range votes {
			if count > votes[winner] {
				winner = topic
			}
		}
		return c.JSON(http.StatusOK, winner)
	})

	e.Logger.Fatal(e.Start(":8081"))
}
