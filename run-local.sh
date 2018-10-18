#https://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file

. common.sh

logs=$(pwd)/build-log.txt
rm -f $logs
set -e

# build and run voting api
pushd ./src/voting-api/
./deps.sh
go build -o voting-api 
pkill voting-api &>> $logs || true
./voting-api &>> $logs &
popd

# build and run voting ui
pushd ./src/voting-ui/
npm install http-server -g &>> $logs || true
pkill node >> $logs || true
http-server -p 8080 &>> $logs &
popd

# run tests with bash
pushd ./test/voting-api/
./test.sh
popd

# run tests with python
pushd ./test/voting-api-py/
./test.sh
popd
