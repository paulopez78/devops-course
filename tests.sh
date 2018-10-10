url=${1:-"http://localhost:8081/vote"}

http_client(){
  curl \
    --silent \
    --request $1 \
    --data "$2" \
    --url $url \
    --header 'Content-Type: application/json' 
}

start_voting(){
  options=${1// /\",\"}
  echo $options
  http_client POST '{"topics":["'$options'"]}'
}

vote(){
  http_client PUT '{"topic": "'$1'"}'
}

finish_voting(){
  http_client DELETE
}

get_votes(){
  http_client GET 
}

assert_equal(){
  if [ "$1" = "$2" ]; then
    echo "Test passed!"
    return 0
  else
    echo "Test failed"
    return -1
  fi
}