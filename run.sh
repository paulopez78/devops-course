set -e
docker-compose stop && docker-compose rm -f
docker-compose up --build -d
docker-compose run --rm voting-api-tests sh -c "./test.sh"