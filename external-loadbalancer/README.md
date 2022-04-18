### exposing an external IP address to access an application in k8s cluster

This example uses Haproxy server VM as an external load balancer.

Networks:
```
Physical Network -> [Haproxy load balancer] -> Virtual Network -> [K8s Cluster]
192.168.1.0/24       192.168.1.100
                     192.168.122.103           192.168.122.0/24    192.168.122.10 (master)
                                                                   192.168.122.11 (worker1)
                                                                   192.168.122.13 (worker2)
                                                                   192.168.122.13 (worker3)
```

"LoadBalancer" type of service needs integration with external load balancing in order to expose the service externally. This is what the lab enviornment does not have.

So we setup an "Haproxy" VM as load balancer and manually configure the haproxy to load balancing to cluster worker node with service's node port.

My understanding, in perfect world, the service gets an "external IP" (or floating IP) from external load balancer and the load balancer gets and configures "backend IP (worker node IP) and port (Node Port)" from the service automatically.


### expose service via kubectl expose
Assign NodePort 30080 for load balancing
```
# create service for the hello-world deployment via kubectl
$ kubectl expose deployment hello-world --type=LoadBalancer --target-port=8080 --port=80 --protocol=TCP --external-ip=192.168.1.100 --name=hello-world

!!! kubectl expose command does not support to specify a node port number.

# manually patch service nodeport to 30080
$ kubectl patch svc hello-world -p '{"spec":{"ports":[{"port":80,"nodePort":30080}]}}'


```

### haporxy config
Add config in /etc/haproxy.cfg and run "systemctl reload haproxy"
```
frontend hello_world_in
        bind 192.168.1.100:80
        mode http
        use_backend hello_world_out

backend hello_world_out
        server worker1 192.168.122.11:30080
        server worker2 192.168.122.12:30080
        server worker3 192.168.122.13:30080
```


### reference
https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/
https://medium.com/swlh/kubernetes-external-ip-service-type-5e5e9ad62fcd
https://www.domstamand.com/adding-haproxy-as-load-balancer-to-the-kubernetes-cluster/
https://www.domstamand.com/installing-a-kubernetes-cluster-on-vmware-vsphere-and-what-ive-learned/
