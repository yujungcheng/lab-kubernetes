#### used commands

get pod name by filter with labels
```
$ kubectl get pod -o wide -l app=work-queue,lab.name=job.work-queue -o jsonpath='{.items[0].metadata.name}'
resource-queue-tgmzl
```

port-forward to the service
```
$ kubectl port-forward resource-queue-tgmzl 8080:8080
Forwarding from 0.0.0.0:8080 -> 8080
```

check MemQ server stats
```
$ curl 127.0.0.1:8080/memq/server/stats
{"kind":"stats","queues":[{"name":"keygen","depth":100,"enqueued":100,"dequeued":0,"drained":0}]}
```

create queue named 'keygen'
```
$ curl -X PUT localhost:8080/memq/server/queues/keygen
```

create 100 task items
```
for i in work-item-{0..99}; do
  curl -X POST localhost:8080/memq/server/queues/keygen/enqueue -d "$i"
done
```