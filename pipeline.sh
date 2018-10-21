#!/bin/bash
. common.sh
. ./src/voting-api/deps.sh
. ./src/voting-ui/deps.sh
. ./test/voting-api/test.sh

run_pipeline(){
  # build and run voting api
  pushd ./src/voting-api/
  get_go_deps
  go build -o voting-api || return 1
  restart voting-api 
  popd

  # build and run voting ui
  pushd ./src/voting-ui/
  npm_install
  restart http-server -p 8080 
  popd

  # run tests with bash
  test || return 1
}

if run_pipeline > logs.txt 2> errors.txt ; then
  echo 'GREEN BUILD!'
else
  echo 'RED BUILD!'
fi
