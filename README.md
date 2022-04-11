### lab kubernetes

This repository stores examples of kubernetes usage.

All examples are defined as manifest yaml file.

- node os version: ubuntu 20.04.4 
- kubernetes version: 1.23.5
- kubernetes cni provider: calico

### kubectl command examples
```
# for example, there is only one pod name start with "mysql"

podname="mysql"
kubectl exec -ti $(kubectl get pod -o=name | grep ${podname}) -- bash
kubectl logs $(kubectl get pod -o=name | grep ${podname}) -f
kubectl describe $(kubectl get pod -o=name | grep ${podname})

```


### Reference
https://kubernetes.io/blog/2021/07/14/upcoming-changes-in-kubernetes-1-22/