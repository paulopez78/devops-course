package main

import (
	"net/http"

	"golang.org/x/net/websocket"

	"github.com/labstack/echo"
)

var (
	votes = make(map[string]int)
	ws    *websocket.Conn
)

type VotingOptions struct {
	Topics []string `json:"topics"`
}

type VoteOption struct {
	Topic string `json:"topic"`
}

type VotingState struct {
	Votes  map[string]int `json:"votes"`
	Winner string         `json:"winner"`
}

func GetVotes(c echo.Context) error {
	return c.JSON(http.StatusOK, VotingState{votes, ""})
}

func StartVoting(c echo.Context) error {
	topics := new(VotingOptions)
	if err := c.Bind(topics); err != nil {
		return err
	}

	for _, val := range topics.Topics {
		votes[val] = 0
	}

	SendVotes(c)

	return c.JSON(http.StatusOK, VotingState{votes, ""})
}

func Vote(c echo.Context) error {
	topic := new(VoteOption)
	if err := c.Bind(&topic); err != nil {
		return err
	}
	votes[topic.Topic]++
	return c.JSON(http.StatusOK, VotingState{votes, ""})
}

func FinishVoting(c echo.Context) error {
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

	return c.JSON(http.StatusOK, VotingState{votes, winner})
}

func SendVotes(c echo.Context) {
	err := websocket.Message.Send(ws, votes)
	if err != nil {
		c.Logger().Error(err)
	}
}

func StartWebSocket(c echo.Context) error {
	websocket.Handler(func(ws *websocket.Conn) {
		defer ws.Close()
	}).ServeHTTP(c.Response(), c.Request())
	return nil
}
