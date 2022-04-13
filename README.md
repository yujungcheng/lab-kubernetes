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


### k8s tool
https://github.com/derailed/k9s/releases



### Reference
https://kubernetes.io/blog/2021/07/14/upcoming-changes-in-kubernetes-1-22/

https://github.com/kubernetes-up-and-running/examples

https://lapee79.github.io/en/article/use-a-local-disk-by-local-volume-static-provisioner-in-kubernetes/
https://blog.vikki.in/kubernetes-stateful-set-with-local-storage-persistent-volume/
https://developer.aliyun.com/article/708483
https://gaurav-kaushikgk88.medium.com/draining-uncordoning-in-a-kubernetes-cluster-7822dda01f0f

https://projectcalico.docs.tigera.io/about/about-kubernetes-services

https://kubernetes.io/docs/reference/kubectl/cheatsheet/

https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
https://kubernetes.io/docs/concepts/storage/persistent-volumes/
https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/
https://kubernetes.io/docs/concepts/storage/storage-classes/
https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container


http://pwittrock.github.io/docs/getting-started-guides/scratch/#network

