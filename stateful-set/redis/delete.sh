#!/bin/bash

kubectl delete -f redis.yaml
kubectl delete -f service.yaml
kubectl delete configmap redis-config
