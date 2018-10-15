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
  http_client POST '{"topics":["'$options'"]}' > /dev/null
}

vote(){
  http_client PUT '{"topic": "'$1'"}' > /dev/null
}

finish_voting(){
  http_client DELETE
}

get_votes(){
  http_client GET 
}

assert_equal(){
  expected=$1
  actual=${2//\"/}

  if [ "$expected" = "$actual" ]; then
    echo "Test passed!"
    exit 0
  else
    echo "Test failed"
    exit -1
  fi
}