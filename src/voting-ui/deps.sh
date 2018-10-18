
#!/bin/bash
npm_install(){
  npm install http-server -g
}

main(){
  npm_install
}

if [ "$1" == 'main' ]; then main; fi