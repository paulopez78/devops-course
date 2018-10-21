set -e

run_pipeline(){
    docker-compose stop && docker-compose rm -f || true
    docker-compose up --build -d || return 1
    docker-compose run --rm voting-api-tests sh -c "./test.sh main" || return 1
    docker-compose push || return 1
}

if run_pipeline; then
    echo "Build finished succesfully!"
else
    echo "Build failed!" 
fi