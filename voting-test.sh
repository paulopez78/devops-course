api="http://localhost:8081/vote"

start_voting(){
  curl -X POST -d "$1" $api 
}

get_votes(){
  curl $api 
}

start_voting "['.netcore', 'golang', 'nodejs']" 
get_votes
