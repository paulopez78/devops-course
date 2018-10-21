
create_network(){
  docker network create $network || true
}

run_redis(){
  docker rm -f redis || true
  docker run \
    --name redis \
    --network $network -d \
    redis
}

build_run_votingapp(){
  local images="voting-ui voting-api"
  port=8080

  for image in $images
  do
    docker build -t $image ./src/$image
    docker rm -f $image || true
    docker run \
      --network $network \
      --name $image -d \
      -e REDIS="redis:6379" \
      -p $port:80 $image 
    port=$((port + 1))
  done
}

run_tests(){
  local test_image="voting-api-tests"
  docker build -t $test_image ./test/voting-api
  docker run \
    --network $network \
    --rm \
    -e VOTING_API="http://voting-api/vote" \
    $test_image \
    sh -c "./test.sh main"
}

set -e
network="voting-app"

create_network
run_redis
build_run_votingapp

if run_tests; then
    echo "Build finished succesfully!"
else
    echo "Build failed!" 
fi