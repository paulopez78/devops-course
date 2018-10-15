set -e
image="voting-api"
docker build -t $image -f ./src/$image/Dockerfile ./src/$image
docker run -p 8081:8081 $image