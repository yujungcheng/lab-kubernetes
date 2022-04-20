#### test
Check master IP from one of redis pod, redis container.
```
$ kubectl exec redis-2 -c redis -- redis-cli -p 26379 sentinel get-master-addr-by-name redis
10.85.235.173
6379
```

Get value of foo from redis server. It should return empty.
```
$ kubectl exec redis-2 -c redis -- redis-cli -p 6379 get foo
```

Write value to foo via redis slave.
```
$ kubectl exec redis-2 -c redis -- redis-cli -p 6379 set foo 1000
READONLY You can't write against a read only replica.
```

Write value to foo via redis master.
```
$ kubectl exec redis-0 -c redis -- redis-cli -p 6379 set foo 1000
OK
```

Get foo value from redis slaves.
```
$ kubectl exec redis-1 -c redis -- redis-cli -p 6379 get foo
1000

$ kubectl exec redis-2 -c redis -- redis-cli -p 6379 get foo
1000
```