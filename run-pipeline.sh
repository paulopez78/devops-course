#!/bin/bash
. common.sh
. ./src/voting-api/deps.sh
. ./test/voting-api/test.sh
. ./test/voting-api-py/test.sh

run_pipeline(){
  # build and run voting api
  pushd ./src/voting-api/
  go build -o voting-api || return 1
  restart voting-api 
  popd

  # build and run voting ui
  pushd ./src/voting-ui/
  npm install http-server -g
  restart http-server -p 8080 
  popd

  # run tests with bash
  test_bash || return 1

  # run tests with python
  pushd ./test/voting-api-py/
  install_venv
  test_py || return 1
  popd
}

if run_pipeline > logs.txt 2> errors.txt ; then
  echo 'GREEN BUILD!'
else
  echo 'RED BUILD!'
fi
