#### Ceph Storage

Use Ceph RBD for dynamic persistent volume with Cassandra.


### Install Ceph CSI RBD plugin
To be updated...


#### test result
```
$ kubectl get statefulset cassandra
NAME        READY   AGE
cassandra   3/3     12m

$ kubectl get pvc -o wide | grep cassandra
NAME                         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE   VOLUMEMODE
cassandra-data-cassandra-0   Bound    pvc-caa4c7f2-a08e-4c49-8e6d-831b088298fb   1Gi        RWO            csi-rbd-sc            13m   Filesystem
cassandra-data-cassandra-1   Bound    pvc-99e35a77-923a-412a-bed1-8133e43aeb7c   1Gi        RWO            csi-rbd-sc            13m   Filesystem
cassandra-data-cassandra-2   Bound    pvc-65e58a45-17ce-4191-86eb-fe2957154708   1Gi        RWO            csi-rbd-sc            12m   Filesystem

$ kubectl get pv -o wide | grep cassandra
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                STORAGECLASS          REASON   AGE   VOLUMEMODE
pvc-65e58a45-17ce-4191-86eb-fe2957154708   1Gi        RWO            Delete           Bound    default/cassandra-data-cassandra-2   csi-rbd-sc                     13m   Filesystem
pvc-99e35a77-923a-412a-bed1-8133e43aeb7c   1Gi        RWO            Delete           Bound    default/cassandra-data-cassandra-1   csi-rbd-sc                     14m   Filesystem
pvc-caa4c7f2-a08e-4c49-8e6d-831b088298fb   1Gi        RWO            Delete           Bound    default/cassandra-data-cassandra-0   csi-rbd-sc                     14m   Filesystem

# check ceph rbd list
$ sudo rbd ls -l
[sudo] password for ubuntu: 
NAME                                          SIZE   PARENT  FMT  PROT  LOCK
csi-vol-05bc43e7-c49a-11ec-b8f2-f2a82c0bebdf  1 GiB            2            
csi-vol-278d3561-c49a-11ec-b8f2-f2a82c0bebdf  1 GiB            2            
csi-vol-ff699b9d-c499-11ec-b8f2-f2a82c0bebdf  1 GiB            2 
```

#### reference
https://computingforgeeks.com/persistent-storage-for-kubernetes-with-ceph-rbd/
https://www.gushiciku.cn/pl/ptAi/zh-tw
https://github.com/kubernetes/examples/tree/master/volumes

> Kubernetes CSI
https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/
https://github.com/kubernetes-csi
https://kubernetes-csi.github.io/
https://kubernetes-csi.github.io/docs/

> Issue with supporting Ceph RBD in Kubernetes.
https://github.com/kubernetes/kubernetes/issues/71904
https://github.com/rootsongjc/kubernetes-handbook/issues/73
https://github.com/kubernetes/kubernetes/issues/85454
https://github.com/kubernetes/kubernetes/pull/95361


> Ceph CSI
https://github.com/ceph/ceph-csi/
https://github.com/ceph/ceph-csi/blob/devel/docs/deploy-rbd.md

