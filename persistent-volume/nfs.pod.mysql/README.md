### overview

This example use "NFS" shared storage in PV to store Mysql database data.

The master node runs NFS server and export "/mnt/nfs/database" to a PV.
Mysql database is running by using replica set with replica count 1.


### resources status
```
ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get pv -o wide
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM              STORAGECLASS   REASON   AGE     VOLUMEMODE
database   2Gi        RWX            Retain           Bound    default/database                           7m30s   Filesystem

ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get pvc -o wide
NAME       STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
database   Bound    database   2Gi        RWX                           7m35s   Filesystem

ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get rs -o wide
NAME    DESIRED   CURRENT   READY   AGE     CONTAINERS   IMAGES         SELECTOR
mysql   1         1         1       7m39s   mysql-db     mysql:5.7.37   app=mysql

ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get svc -o wide
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE     SELECTOR
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP    14d     <none>
mysql        ClusterIP   10.96.152.127   <none>        3306/TCP   7m46s   app=mysql

ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get pod -o wide -l app=mysql
NAME          READY   STATUS    RESTARTS       AGE     IP             NODE      NOMINATED NODE   READINESS GATES
mysql-c75kl   1/1     Running   1 (5m9s ago)   9m10s   10.85.189.71   worker2   <none>           <none>


ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl get secret -o wide
NAME                  TYPE                                  DATA   AGE
mysql-root-password   Opaque                                1      9m28s


# check the test account created by init script. (from an ubuntu pod with mysql client)
ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl exec -ti -n demo ubuntu -- mysql -h mysql.default -u test -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 35
Server version: 5.7.37 MySQL Community Server (GPL)

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

#### notes 

```
# mysql 8 image bug ?
# https://topic.alibabacloud.com/a/mysql-official-source-does-not-boot-after-upgrading-from-803-direct-yum-to-804_1_41_30016705.html
ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl logs mysql-hwt5g -f
2022-04-08 01:53:01+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
2022-04-08 01:53:03+00:00 [Note] [Entrypoint]: Switching to dedicated user 'mysql'
2022-04-08 01:53:03+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.28-1debian10 started.
2022-04-08T01:53:04.744719Z 0 [System] [MY-010116] [Server] /usr/sbin/mysqld (mysqld 8.0.28) starting as process 1
2022-04-08T01:53:05.299004Z 1 [System] [MY-013576] [InnoDB] InnoDB initialization has started.
2022-04-08T01:53:10.866022Z 1 [System] [MY-013577] [InnoDB] InnoDB initialization has ended.
2022-04-08T01:53:10.869833Z 1 [ERROR] [MY-011096] [Server] No data dictionary version number found.
2022-04-08T01:53:10.870061Z 0 [ERROR] [MY-010020] [Server] Data Dictionary initialization failed.
2022-04-08T01:53:10.870231Z 0 [ERROR] [MY-010119] [Server] Aborting
2022-04-08T01:53:13.282953Z 0 [System] [MY-010910] [Server] /usr/sbin/mysqld: Shutdown complete (mysqld 8.0.28)  MySQL Community Server - GPL.
```
```
# the mysql pod logs has following error due to the livenessProbe.
ubuntu@master:~/lab-kubernetes/persistent-volume/pod$ kubectl logs mysql-c75kl | tail
2022-04-11T00:04:35.852363Z 3201 [Note] Got an error reading communication packets
2022-04-11T00:04:45.850347Z 3202 [Note] Got an error reading communication packets
2022-04-11T00:04:55.851297Z 3203 [Note] Got an error reading communication packets
2022-04-11T00:05:05.850596Z 3204 [Note] Got an error reading communication packets
2022-04-11T00:05:15.851461Z 3205 [Note] Got an error reading communication packets
2022-04-11T00:05:25.852368Z 3206 [Note] Got an error reading communication packets
2022-04-11T00:05:35.851843Z 3207 [Note] Got an error reading communication packets
2022-04-11T00:05:45.851614Z 3208 [Note] Got an error reading communication packets
2022-04-11T00:05:55.850619Z 3209 [Note] Got an error reading communication packets
2022-04-11T00:06:05.851910Z 3210 [Note] Got an error reading communication packets

ubuntu@master:~$ kubectl describe pod mysql-c75kl | grep Liveness
    Liveness:  tcp-socket :3306 delay=0s timeout=1s period=10s #success=1 #failure=3
```
