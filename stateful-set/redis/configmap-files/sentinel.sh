#!/bin/bash

while ! ping -c 1 redis-0.redis; do
    echo 'Waiting for server'
    sleep 1
done

sleep 10

# copy config file to /etc for file to be updated.
cp /redis-config/sentinel.conf /etc/
redis-sentinel /etc/sentinel.conf
