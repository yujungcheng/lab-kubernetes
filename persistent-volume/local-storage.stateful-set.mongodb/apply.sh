#!/usr/bin/bash


kubectl apply -f mongo-headless-service.yaml
kubectl apply -f mongo-config-map.yaml
kubectl apply -f mongo.yaml