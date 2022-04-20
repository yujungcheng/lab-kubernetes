#!/bin/bash


# create config map
kubectl create configmap \
  --from-file=slave.conf=./configmap-files/slave.conf \
  --from-file=master.conf=./configmap-files/master.conf \
  --from-file=sentinel.conf=./configmap-files/sentinel.conf \
  --from-file=init.sh=./configmap-files/init.sh \
  --from-file=sentinel.sh=./configmap-files/sentinel.sh \
  redis-config

# create service
kubectl apply -f service.yaml

# create redis
kubectl apply -f redis.yaml