### some command short cut
```
podname="mysql"
kubectl exec -ti $(kubectl get pod -o=name | grep ${podname}) -- bash
kubectl describe $(kubectl get pod -o=name | grep ${podname})
```


### Reference
https://kubernetes.io/blog/2021/07/14/upcoming-changes-in-kubernetes-1-22/