
#### daemonset on all nodes
```
$ kubectl get daemonset -n kube-system -l app=fluentd
NAME      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
fluentd   3         3         3       3            3           <none>          71s
```
```
$ kubectl get pod -n kube-system -o wide -l app=fluentd
NAME            READY   STATUS    RESTARTS   AGE    IP              NODE      NOMINATED NODE   READINESS GATES
fluentd-9vqws   1/1     Running   0          115s   10.85.235.154   worker1   <none>           <none>
fluentd-hd9rz   1/1     Running   0          115s   10.85.189.103   worker2   <none>           <none>
fluentd-l27ck   1/1     Running   0          115s   10.85.182.58    worker3   <none>           <none>

```
```
$ kubectl describe daemonset -n kube-system fluentd
Name:           fluentd
Selector:       app=fluentd
Node-Selector:  <none>
Labels:         app=fluentd
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 3
Current Number of Nodes Scheduled: 3
Number of Nodes Scheduled with Up-to-date Pods: 3
Number of Nodes Scheduled with Available Pods: 3
Number of Nodes Misscheduled: 0
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=fluentd
  Containers:
   fluentd:
    Image:      fluent/fluentd:v1.14.6-debian-1.0
    Port:       <none>
    Host Port:  <none>
    Limits:
      memory:  200Mi
    Requests:
      cpu:        100m
      memory:     200Mi
    Environment:  <none>
    Mounts:
      /var/lib/docker/containers from varlibdockercontainers (ro)
      /var/log from varlog (rw)
  Volumes:
   varlog:
    Type:          HostPath (bare host directory volume)
    Path:          /var/log
    HostPathType:  
   varlibdockercontainers:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/docker/containers
    HostPathType:  
Events:
  Type    Reason            Age    From                  Message
  ----    ------            ----   ----                  -------
  Normal  SuccessfulCreate  5m47s  daemonset-controller  Created pod: fluentd-9vqws
  Normal  SuccessfulCreate  5m46s  daemonset-controller  Created pod: fluentd-l27ck
  Normal  SuccessfulCreate  5m46s  daemonset-controller  Created pod: fluentd-hd9rz

```

#### daemon-set with node selector
add label to worker nodes
```
$ kubectl label nodes worker1 worker3 odd_node=true
node/worker1 labeled
node/worker3 labeled
$ kubectl label nodes worker2 even_node=true
node/worker2 labeled

$ kubectl get node -l odd_node
NAME      STATUS   ROLES    AGE   VERSION
worker1   Ready    <none>   37d   v1.23.5
worker3   Ready    <none>   37d   v1.23.5

$ kubectl get nodes --selector odd_node=true
NAME      STATUS   ROLES    AGE   VERSION
worker1   Ready    <none>   37d   v1.23.5
worker3   Ready    <none>   37d   v1.23.5

$ kubectl get node -l even_node
NAME      STATUS   ROLES    AGE   VERSION
worker2   Ready    <none>   37d   v1.23.5

!!! to remove label, eg. append minus sign - after the label name
$ kubectl label nodes worker2 even_node-
```
deploy daemonset with node selector on odd number nodes.
```
$ kubectl apply -f nginx.with-nodeSelector.yaml
daemonset.apps/nginx-on-odd-nodes created

$ kubectl get daemonset -o wide
NAME                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE   CONTAINERS   IMAGES         SELECTOR
nginx-on-odd-nodes   2         2         2       2            2           odd_node=true   38s   nginx        nginx:1.21.6   app=nginx,on_odd_node=true

$ kubectl get pod -l on_odd_node=true -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP              NODE      NOMINATED NODE   READINESS GATES
nginx-on-odd-nodes-c7m5b   1/1     Running   0          2m40s   10.85.235.146   worker1   <none>           <none>
nginx-on-odd-nodes-zc7xl   1/1     Running   0          2m40s   10.85.182.60    worker3   <none>           <none>

$ kubectl describe daemonset nginx-on-odd-nodes
Name:           nginx-on-odd-nodes
Selector:       app=nginx,on_odd_node=true
Node-Selector:  odd_node=true
Labels:         app=nginx
                node=odd
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 2
Current Number of Nodes Scheduled: 2
Number of Nodes Scheduled with Up-to-date Pods: 2
Number of Nodes Scheduled with Available Pods: 2
Number of Nodes Misscheduled: 0
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=nginx
           on_odd_node=true
  Containers:
   nginx:
    Image:        nginx:1.21.6
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type    Reason            Age    From                  Message
  ----    ------            ----   ----                  -------
  Normal  SuccessfulCreate  3m34s  daemonset-controller  Created pod: nginx-on-odd-nodes-zc7xl
  Normal  SuccessfulCreate  3m34s  daemonset-controller  Created pod: nginx-on-odd-nodes-c7m5b
```


#### reference
https://hub.docker.com/r/fluent/fluentd
https://github.com/fluent/fluentd-kubernetes-daemonset