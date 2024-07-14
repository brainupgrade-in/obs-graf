#!/bin/bash

APP_URL=$1
TIMES=$2
for i in $(eval echo "{1..$TIMES}")
do
    siege -c 1 -r 10 http://$APP_URL/
    siege -c 3 -r 5 http://$APP_URL/io_task
    siege -c 2 -r 5 http://$APP_URL/cpu_task
    siege -c 5 -r 3 http://$APP_URL/random_sleep
    siege -c 2 -r 10 http://$APP_URL/random_status
    siege -c 2 -r 3 http://$APP_URL/chain
    siege -c 1 -r 1 http://$APP_URL/error_test
    sleep 5
done