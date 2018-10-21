
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

push_images(){
  for image in $images
  do
    registry_image=${REGISTRY:-'local'}/$image
    docker tag $image $registry_image    
    docker push $registry_image
  done
}

set -e

images="voting-ui voting-api"
network="voting-app"

create_network
run_redis
build_run_votingapp

if run_tests; then
    push_images
    echo "Build finished succesfully!"
else
    echo "Build failed!" 
fi