#!/bin/bash

action="apply"

kubectl ${action} -f ../mongo-config-map.yaml
kubectl ${action} -f ../mongo-headless-service.yaml

kubectl ${action} -f storage-class.yaml

kubectl ${action} -f pv-pvc-worker1.yaml
kubectl ${action} -f pv-pvc-worker2.yaml
kubectl ${action} -f pv-pvc-worker3.yaml

kubectl ${action} -f mongo.yaml