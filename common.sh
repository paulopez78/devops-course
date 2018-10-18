#!/bin/bash
restart(){
    program=$1
    pids=$(ps aux | grep $program | awk '{ print $2 }')
    if [ -n "$pids" ]; then
        for id in $pids
        do
            kill -9 $id || true
        done
    fi

    (./$program || $program) &
}