### install metal load balancer
The kube-proxy is in "iptables" mode by default, no need to enable strict ARP mode. 
```
# create metallb-system namespace
$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
namespace/metallb-system created

# create metalb workloads in metallb-system namespace
$ kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
Warning: policy/v1beta1 PodSecurityPolicy is deprecated in v1.21+, unavailable in v1.25+
podsecuritypolicy.policy/controller created
podsecuritypolicy.policy/speaker created
serviceaccount/controller created
serviceaccount/speaker created
clusterrole.rbac.authorization.k8s.io/metallb-system:controller created
clusterrole.rbac.authorization.k8s.io/metallb-system:speaker created
role.rbac.authorization.k8s.io/config-watcher created
role.rbac.authorization.k8s.io/pod-lister created
role.rbac.authorization.k8s.io/controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:controller created
clusterrolebinding.rbac.authorization.k8s.io/metallb-system:speaker created
rolebinding.rbac.authorization.k8s.io/config-watcher created
rolebinding.rbac.authorization.k8s.io/pod-lister created
rolebinding.rbac.authorization.k8s.io/controller created
daemonset.apps/speaker created
deployment.apps/controller created
```

### configuration
create and apply config map manifest file.
```
# metallb-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 192.168.122.240-192.168.122.250

```
Set addresses 192.168.122.240 to 192.168.122.250 for "External IP" pool.


### test
1. apply "hello-world" deployment from "external-loadbalancer" first.
2. expose the hello-world deployment without specify "external IP"
```
$ kubectl expose deployment hello-world --type=LoadBalancer --target-port=8080 --port=80 --protocol=TCP --name=hello-world
service/hello-world exposed

$ kubectl get svc -o wide hello-world
NAME          TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)        AGE   SELECTOR
hello-world   LoadBalancer   10.101.52.49   192.168.122.240   80:30832/TCP   19s   app=hello-world

$ kubectl get svc -o yaml hello-world
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: "2022-04-19T02:01:58Z"
  labels:
    name: hello-world
  name: hello-world
  namespace: default
  resourceVersion: "2471323"
  uid: effbd16f-0b07-4566-9afa-1cfe1b1a239e
spec:
  allocateLoadBalancerNodePorts: true
  clusterIP: 10.101.52.49
  clusterIPs:
  - 10.101.52.49
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30832
    port: 80
    protocol: TCP
    targetPort: 8080
  selector:
    app: hello-world
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - ip: 192.168.122.240


$ kubectl describe svc hello-world
Name:                     hello-world
Namespace:                default
Labels:                   name=hello-world
Annotations:              <none>
Selector:                 app=hello-world
Type:                     LoadBalancer
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       10.101.52.49
IPs:                      10.101.52.49
LoadBalancer Ingress:     192.168.122.240
Port:                     <unset>  80/TCP
TargetPort:               8080/TCP
NodePort:                 <unset>  30832/TCP
Endpoints:                10.85.182.34:8080,10.85.189.92:8080,10.85.235.162:8080
Session Affinity:         None
External Traffic Policy:  Cluster
Events:
  Type    Reason        Age   From                Message
  ----    ------        ----  ----                -------
  Normal  IPAllocated   58s   metallb-controller  Assigned IP ["192.168.122.240"]
  Normal  nodeAssigned  58s   metallb-speaker     announcing from node "worker1"
```


### reference
https://metallb.universe.tf/
https://github.com/metallb/metallb/tree/f691c94622a5ab0aab29511df9911cf7bf1f94ac

https://www.akiicat.com/2019/04/19/Kubernetes/metallb-installation-for-bare-metal/
https://atbug.com/load-balancer-service-with-metallb/

