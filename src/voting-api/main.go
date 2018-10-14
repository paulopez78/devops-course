package main

import (
	"log"
	"net/http"

	"github.com/gorilla/websocket"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

var (
	upgrader = websocket.Upgrader{CheckOrigin: func(r *http.Request) bool { return true }}
	clients  []*websocket.Conn
)

func main() {

	e := echo.New()

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{echo.GET, echo.HEAD, echo.PUT, echo.PATCH, echo.POST, echo.DELETE},
	}))

	api := "/vote"
	e.GET(api, get)
	e.POST(api, startVoting)
	e.PUT(api, vote)
	e.DELETE(api, finishVoting)
	e.GET("/ws", serveWs)

	e.Logger.Fatal(e.Start(":8081"))
}

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
