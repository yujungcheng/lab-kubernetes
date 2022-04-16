#!/bin/bash

kubectl create configmap --from-file ghost-config.sqlite3.js ghost-config-sqlite3
kubectl create configmap --from-file ghost-config.mysql.js ghost-config-mysql

kubectl apply -f ghost.mysql.yaml

kubectl expose deployment ghost --port=2368