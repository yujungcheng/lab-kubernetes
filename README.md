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


### network tools to install
```
DEBIAN_FRONTEND=noninteractive apt install -y dnsutils iputils-ping net-tools
```


### Reference
https://kubernetes.io/blog/2021/07/14/upcoming-changes-in-kubernetes-1-22/
https://lapee79.github.io/en/article/use-a-local-disk-by-local-volume-static-provisioner-in-kubernetes/
https://blog.vikki.in/kubernetes-stateful-set-with-local-storage-persistent-volume/
https://developer.aliyun.com/article/708483
