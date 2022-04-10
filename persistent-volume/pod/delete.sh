#!/usr/bin/bash

kubectl delete -f mysql-service.yaml
kubectl delete -f mysql-replica-set.yaml
kubectl delete -f mysql-secret.yaml
kubectl delete -f mysql-config-map.yaml
kubectl delete -f nfs-volume-claim.yaml
kubectl delete -f nfs-volume.yaml