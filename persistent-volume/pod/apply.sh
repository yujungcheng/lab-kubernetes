#!/usr/bin/bash

kubectl apply -f nfs-volume.yaml
kubectl apply -f nfs-volume-claim.yaml
kubectl apply -f mysql-config-map.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-replica-set.yaml
kubectl apply -f mysql-service.yaml