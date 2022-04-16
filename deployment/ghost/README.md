### run Ghost blog with deployment

Example of running "Ghost" blog in deployment.

there are two exmples to storage blog data.
1. sqlite3: store inside ghost container
2. mysql: store on mysql database (mysql pod with nfs persistent volume)

### access ghost via kubectl proxy
This way is able to open main page, but still have other
```
Network:
**nuc8 (with GUI)** --> **nuc10 (VM lab server)** --> **k8s-mater VM**


step 1. run kubectl proxy on k8s-master node
$ kubectl proxy --address=192.168.122.10

step 2. create ssh port forwarding on nuc8
$ ssh -v -N -L 32000:192.168.122.10:8001 nuc10

step 3. open browser on nuc8 to access following url.
http://localhost:32000/api/v1/namespaces/default/services/ghost/proxy/
```

### mysql database
If connect with mysql, the database has to be created first. 
Run "create.mysql.sh" and make "ghost" database is created.
After the ghost database is created, run "apply.ghost-with-mysql.sh" and check logs, for example:
```
$ kubectl logs ghost-87c44854b-x5bmm -f
[2022-04-16 13:36:18] INFO Ghost is running in production...
[2022-04-16 13:36:18] INFO Your site is now available on http://localhost:2368/
[2022-04-16 13:36:18] INFO Ctrl+C to shut down
[2022-04-16 13:36:18] INFO Ghost server started in 0.473s
[2022-04-16 13:36:20] WARN Database state requires initialisation.
[2022-04-16 13:36:21] INFO Creating table: posts
[2022-04-16 13:36:22] INFO Creating table: posts_meta
[2022-04-16 13:36:24] INFO Creating table: users
[2022-04-16 13:36:26] INFO Creating table: oauth
[2022-04-16 13:36:26] INFO Creating table: posts_authors
```

### configuration
Check ghost tutorials for further configuration

### reference
https://github.com/docker-library/docs/tree/master/ghost
https://ghost.org/docs/tutorials/