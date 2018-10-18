#!/bin/bash

. common.sh

set -e

# build and run voting api
pushd ./src/voting-api/
./deps.sh
go build -o voting-api 
restart voting-api 
popd

# build and run voting ui
pushd ./src/voting-ui/
npm install http-server -g || true
restart http-server -p 8080
popd

# run tests with bash
pushd ./test/voting-api/
./test.sh
popd

# run tests with python
pushd ./test/voting-api-py/
./test.sh
popd
