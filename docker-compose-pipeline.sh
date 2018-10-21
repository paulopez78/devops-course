set -e
docker-compose stop && docker-compose rm -f
docker-compose up --build -d

if docker-compose run --rm voting-api-tests sh -c "./test.sh main"; then
    echo "Build finished succesfully!"
else
    echo "Build failed!" 
fi