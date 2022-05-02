#!/bin/bash

QUEUE='keygen'
START=1
END=100

# Create a work queue
curl -X PUT localhost:8080/memq/server/queues/${QUEUE}

# Create work items and load up the queue.
for (( i = $START; i <= $END; i++ )); do
  curl -X POST localhost:8080/memq/server/queues/${QUEUE}/enqueue -d "$i"
done