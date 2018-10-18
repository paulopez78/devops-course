#!/bin/bash
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
  else
    echo "Test failed"
    return 1
  fi
}

test(){
  voting_options="python bash go"
  voted_options="python go bash bash"
  expected_winner="bash"

  echo "Given [$voting_options] voting options"
  echo "When voted for [$voted_options]"
  echo "Then winner is $expected_winner"
  
  start_voting "$voting_options"

  for topic in $voted_options
  do
    vote $topic
  done

  winner=$(finish_voting | jq '.winner')
  assert_equal $expected_winner $winner 
}

main(){
  test
}

if [ "$1" == 'main' ]; then main; fi