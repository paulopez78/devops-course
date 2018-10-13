package main

import (
	"log"
	"net/http"

	"github.com/labstack/echo"

	"github.com/gorilla/websocket"
)

var (
	upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	clients  []*websocket.Conn
)

func sendMessage(value interface{}) {
	for _, client := range clients {
		client.WriteJSON(value)
	}
}

// serveWs handles websocket requests from the peer.
func serveWs(c echo.Context) error {
	conn, err := upgrader.Upgrade(c.Response(), c.Request(), nil)
	if err != nil {
		log.Println(err)
	}
	clients = append(clients, conn)
	return nil
}
