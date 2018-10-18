
#!/bin/bash

get_go_deps(){
  go get github.com/labstack/echo
  go get github.com/labstack/echo/middleware
  go get github.com/gorilla/websocket
}

main(){
  get_go_deps
}

if [ "$1" == 'main' ]; then main; fi