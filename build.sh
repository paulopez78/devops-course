set -e
images="voting-api voting-ui"
port=8081

for image in $images
do
  docker build -t $image ./src/$image
  docker rm -f $image
  docker run --name $image -d -p $port:80 $image 
  port=$((port + 1))
done