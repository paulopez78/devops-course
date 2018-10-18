
pkill(){
    id=$(ps aux | grep $1 | awk '{ print $1 }')
    if [ -n "$id" ]; then
        kill -9 $id
    fi
}