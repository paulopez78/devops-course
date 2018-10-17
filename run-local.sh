set -e

# build and run voting api
pushd ./src/voting-api/
./deps.sh
go build -o voting-api 
pkill -9 voting-api || true
./voting-api > /dev/null &
popd

# build and run voting ui
pushd ./src/voting-ui/
npm install http-server -g > /dev/null
pkill -9 node || true
http-server -p 8080 > /dev/null &
popd

# run tests with bash
pushd ./test/voting-api/
./test.sh
popd

# run tests with python
pushd ./test/voting-api-py/
./test.sh
popd
