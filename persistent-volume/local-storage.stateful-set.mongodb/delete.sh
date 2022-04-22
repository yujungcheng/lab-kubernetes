#!/usr/bin/bash

kubectl delete -f mongo.yaml
kubectl delete -f mongo-config-map.yaml
kubectl delete -f mongo-headless-service.yaml