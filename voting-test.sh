http_client(){
  api="http://localhost:8081/vote"
  curl \
    --request $1 \
    --data "$2" \
    --url $api \
    --header 'Content-Type: application/json' 
}

start_voting(){
  http_client POST "$1"
}

vote(){
  http_client PUT "$1"
}

finish_voting(){
  http_client DELETE "$1"
}

get_votes(){
  http_client GET 
}

start_voting '{"topics": ["python","bash", "go"]}'
for topic in python bash go go
do
  vote '{"topic": "'$topic'"}'
done
winner=$(finish_voting)
echo "The winner is $winner"