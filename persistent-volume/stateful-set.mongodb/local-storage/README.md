### Overview
This is example of using local storage as PV in stateful set.
The local storage here is directory path in worker node file system. 
This local directory has to be created firstly on each worker node.


### Description

The PV and PVC is one to one mappiong, so for a local storage on each worker node, we have to create PV and PVC for them.

In the environment, there are 3 worker nodes and we are creating a stateful set with 3 replicas of MongoDB database.
This will allocate each mongodb replica pod on each worker node and mount a local directory to each pod replica.

Here, the local storage directory for mongodb pod to mount is "/mnt/local".
The mongodb container in each replica pod mounts "/mnt/local" to "/data/db" in local storage.

The stateful set created is called "mongo", pod created are named mongo-0, mongo-1 and mongo-2
In the stateful set, "volumeClaimTemplates" is used to provide mapping the replica pod to a PVC.

The way "volumeClaimTemplates" to match a PVC by naming of "volumeClaimTemplates" name + '-' + "stateful set" name + '-' + "sequence number".

For example, the "volumeClaimTemplates" name defined in the stateful set is "local-pvc".
For mongo-0 pod, it matches for PVC `local-pvc-mongo-0`
For mongo-1 pod, it matches for PVC `local-pvc-mongo-1`
For mongo-2 pod, it matches for PVC `local-pvc-mongo-2`

Thereforce, those PVC must defined and created firstly in order to get replica pod able to bind the PV.


### Result
```
ubuntu@master:~$ kubectl get statefulset -o wide
NAME    READY   AGE   CONTAINERS             IMAGES
mongo   3/3     68m   mongodb,init-mongodb   mongo:5.0.6-focal,mongo:5.0.6-focal

ubuntu@master:~$ kubectl get pod -o wide
NAME            READY   STATUS    RESTARTS        AGE     IP              NODE      NOMINATED NODE   READINESS GATES
mongo-0         2/2     Running   0               68m     10.85.235.158   worker1   <none>           <none>
mongo-1         2/2     Running   0               68m     10.85.189.87    worker2   <none>           <none>
mongo-2         2/2     Running   0               68m     10.85.182.25    worker3   <none>           <none>

ubuntu@master:~$ kubectl get pv -o wide
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                       STORAGECLASS          REASON   AGE   VOLUMEMODE
local-pv-worker1   1Gi        RWO            Retain           Bound    default/local-pvc-mongo-0   local-storage-class            69m   Filesystem
local-pv-worker2   1Gi        RWO            Retain           Bound    default/local-pvc-mongo-1   local-storage-class            69m   Filesystem
local-pv-worker3   1Gi        RWO            Retain           Bound    default/local-pvc-mongo-2   local-storage-class            69m   Filesystem

ubuntu@master:~$ kubectl get pvc -o wide
NAME                STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS          AGE   VOLUMEMODE
local-pvc-mongo-0   Bound    local-pv-worker1   1Gi        RWO            local-storage-class   69m   Filesystem
local-pvc-mongo-1   Bound    local-pv-worker2   1Gi        RWO            local-storage-class   69m   Filesystem
local-pvc-mongo-2   Bound    local-pv-worker3   1Gi        RWO            local-storage-class   69m   Filesystem
```