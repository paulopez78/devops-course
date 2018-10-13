package main

import (
	"net/http"

	"golang.org/x/net/websocket"

	"github.com/labstack/echo"
)

var (
	state     = VotingState{make(map[string]int), ""}
	publisher *websocket.Conn
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

func Get(c echo.Context) error {
	return PublishState(c)
}

func StartVoting(c echo.Context) error {
	topics := new(VotingOptions)
	if err := c.Bind(topics); err != nil {
		return err
	}

	state = VotingState{make(map[string]int), ""}
	for _, val := range topics.Topics {
		state.Votes[val] = 0
	}

	return PublishState(c)
}

func Vote(c echo.Context) error {
	topic := new(VoteOption)
	if err := c.Bind(&topic); err != nil {
		return err
	}
	state.Votes[topic.Topic]++
	return PublishState(c)
}

func FinishVoting(c echo.Context) error {
	var winner string
	for topic := range state.Votes {
		winner = topic
		break
	}
	for topic, count := range state.Votes {
		if count > state.Votes[winner] {
			winner = topic
		}
	}
	state.Winner = winner
	return PublishState(c)
}

func PublishState(c echo.Context) error {
	err := websocket.Message.Send(publisher, state)
	if err != nil {
		c.Logger().Error(err)
	}
	return c.JSON(http.StatusOK, state)
}

func StartWebSocket(c echo.Context) error {
	websocket.Handler(func(ws *websocket.Conn) {
		publisher = ws
		defer ws.Close()
	}).ServeHTTP(c.Response(), c.Request())
	return nil
}
