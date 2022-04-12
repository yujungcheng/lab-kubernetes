### Overview

This example use stateful-set with config-map to initialize mongodb

The config-map store initialise script and mount to sidecar container in each mongodb pod replica for initialise the mongodb.

mongo-0 pod will be initialised as primary and mongo-1 and mongo-2 will be secondary.


### test dns resolution to mongo db replicas
```
ubuntu@master:~/lab-kubernetes/persistent-volume/stateful-set$ kubectl exec -ti ubuntu -n demo -- bash
root@ubuntu:/# nslookup mongo-0.mongo.default
Server:		10.96.0.10
Address:	10.96.0.10#53

Name:	mongo-0.mongo.default.svc.cluster.local
Address: 10.85.182.13

root@ubuntu:/# nslookup mongo-1.mongo.default
Server:		10.96.0.10
Address:	10.96.0.10#53

Name:	mongo-1.mongo.default.svc.cluster.local
Address: 10.85.235.148

root@ubuntu:/# nslookup mongo-2.mongo.default
Server:		10.96.0.10
Address:	10.96.0.10#53

Name:	mongo-2.mongo.default.svc.cluster.local
Address: 10.85.189.72

root@ubuntu:/# ping -c 2 mongo-0.mongo.default
PING mongo-0.mongo.default.svc.cluster.local (10.85.182.13) 56(84) bytes of data.
64 bytes from mongo-0.mongo.default.svc.cluster.local (10.85.182.13): icmp_seq=1 ttl=62 time=1.31 ms
64 bytes from mongo-0.mongo.default.svc.cluster.local (10.85.182.13): icmp_seq=2 ttl=62 time=0.540 ms

--- mongo-0.mongo.default.svc.cluster.local ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 0.540/0.926/1.313/0.386 ms

root@ubuntu:/# ping -c 2 mongo-1.mongo.default
PING mongo-1.mongo.default.svc.cluster.local (10.85.235.148) 56(84) bytes of data.
64 bytes from mongo-1.mongo.default.svc.cluster.local (10.85.235.148): icmp_seq=1 ttl=63 time=0.254 ms
64 bytes from mongo-1.mongo.default.svc.cluster.local (10.85.235.148): icmp_seq=2 ttl=63 time=0.060 ms

--- mongo-1.mongo.default.svc.cluster.local ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.060/0.157/0.254/0.097 ms
root@ubuntu:/# ping -c 2 mongo-2.mongo.default
PING mongo-2.mongo.default.svc.cluster.local (10.85.189.72) 56(84) bytes of data.
64 bytes from mongo-2.mongo.default.svc.cluster.local (10.85.189.72): icmp_seq=1 ttl=62 time=0.299 ms
64 bytes from mongo-2.mongo.default.svc.cluster.local (10.85.189.72): icmp_seq=2 ttl=62 time=0.474 ms

--- mongo-2.mongo.default.svc.cluster.local ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1026ms
rtt min/avg/max/mdev = 0.299/0.386/0.474/0.087 ms

```


### manually initialise mondb replication
```
ubuntu@master:~/lab-kubernetes/persistent-volume/stateful-set$ kubectl exec -ti mongo-0 mongo
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
MongoDB shell version v5.0.6
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("38b2bc01-9fa6-4618-acf4-d349347471ac") }
MongoDB server version: 5.0.6
================
Warning: the "mongo" shell has been superseded by "mongosh",
which delivers improved usability and compatibility.The "mongo" shell has been deprecated and will be removed in
an upcoming release.
For installation instructions, see
https://docs.mongodb.com/mongodb-shell/install/
================
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	https://docs.mongodb.com/
Questions? Try the MongoDB Developer Community Forums
	https://community.mongodb.com
---
The server generated these startup warnings when booting: 
        2022-04-11T02:39:24.488+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
        2022-04-11T02:39:24.488+00:00: You are running this process as the root user, which is not recommended
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> rs.status()
{
	"ok" : 0,
	"errmsg" : "no replset config has been received",
	"code" : 94,
	"codeName" : "NotYetInitialized"
}
> 
> rs.initiate( { _id: "rs0", members: [ { _id: 0, host: "mongo-0.mongo:27017" } ] } );
{ "ok" : 1 }
rs0:SECONDARY>
rs0:PRIMARY>
rs0:PRIMARY> rs.add("mongo-1.mongo:27017");
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1649644893, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1649644893, 1)
}
rs0:PRIMARY> rs.add("mongo-2.mongo:27017");
{
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1649644899, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1649644899, 1)
}


rs0:PRIMARY> db.getSiblingDB("admin").createUser({user: "admin", pwd: "password", roles: [{role: "root", db: "admin"}]});
Successfully added user: {
	"user" : "admin",
	"roles" : [
		{
			"role" : "root",
			"db" : "admin"
		}
	]
}

```

### check mongo db status
```
rs0:PRIMARY> rs.status()
{
	"set" : "rs0",
	"date" : ISODate("2022-04-11T02:42:29.391Z"),
	"myState" : 1,
	"term" : NumberLong(1),
	"syncSourceHost" : "",
	"syncSourceId" : -1,
	"heartbeatIntervalMillis" : NumberLong(2000),
	"majorityVoteCount" : 2,
	"writeMajorityCount" : 2,
	"votingMembersCount" : 3,
	"writableVotingMembersCount" : 3,
	"optimes" : {
		"lastCommittedOpTime" : {
			"ts" : Timestamp(1649644939, 1),
			"t" : NumberLong(1)
		},
		"lastCommittedWallTime" : ISODate("2022-04-11T02:42:19.353Z"),
		"readConcernMajorityOpTime" : {
			"ts" : Timestamp(1649644939, 1),
			"t" : NumberLong(1)
		},
		"appliedOpTime" : {
			"ts" : Timestamp(1649644949, 1),
			"t" : NumberLong(1)
		},
		"durableOpTime" : {
			"ts" : Timestamp(1649644939, 1),
			"t" : NumberLong(1)
		},
		"lastAppliedWallTime" : ISODate("2022-04-11T02:42:29.354Z"),
		"lastDurableWallTime" : ISODate("2022-04-11T02:42:19.353Z")
	},
	"lastStableRecoveryTimestamp" : Timestamp(1649644893, 1),
	"electionCandidateMetrics" : {
		"lastElectionReason" : "electionTimeout",
		"lastElectionDate" : ISODate("2022-04-11T02:40:38.029Z"),
		"electionTerm" : NumberLong(1),
		"lastCommittedOpTimeAtElection" : {
			"ts" : Timestamp(1649644836, 1),
			"t" : NumberLong(-1)
		},
		"lastSeenOpTimeAtElection" : {
			"ts" : Timestamp(1649644836, 1),
			"t" : NumberLong(-1)
		},
		"numVotesNeeded" : 1,
		"priorityAtElection" : 1,
		"electionTimeoutMillis" : NumberLong(10000),
		"newTermStartDate" : ISODate("2022-04-11T02:40:38.790Z"),
		"wMajorityWriteAvailabilityDate" : ISODate("2022-04-11T02:40:39.584Z")
	},
	"members" : [
		{
			"_id" : 0,
			"name" : "mongo-0.mongo:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 188,
			"optime" : {
				"ts" : Timestamp(1649644949, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2022-04-11T02:42:29Z"),
			"lastAppliedWallTime" : ISODate("2022-04-11T02:42:29.354Z"),
			"lastDurableWallTime" : ISODate("2022-04-11T02:42:19.353Z"),
			"syncSourceHost" : "",
			"syncSourceId" : -1,
			"infoMessage" : "Could not find member to sync from",
			"electionTime" : Timestamp(1649644838, 1),
			"electionDate" : ISODate("2022-04-11T02:40:38Z"),
			"configVersion" : 5,
			"configTerm" : 1,
			"self" : true,
			"lastHeartbeatMessage" : ""
		},
		{
			"_id" : 1,
			"name" : "mongo-1.mongo:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 56,
			"optime" : {
				"ts" : Timestamp(1649644939, 1),
				"t" : NumberLong(1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1649644939, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2022-04-11T02:42:19Z"),
			"optimeDurableDate" : ISODate("2022-04-11T02:42:19Z"),
			"lastAppliedWallTime" : ISODate("2022-04-11T02:42:29.354Z"),
			"lastDurableWallTime" : ISODate("2022-04-11T02:42:29.354Z"),
			"lastHeartbeat" : ISODate("2022-04-11T02:42:28.429Z"),
			"lastHeartbeatRecv" : ISODate("2022-04-11T02:42:28.478Z"),
			"pingMs" : NumberLong(0),
			"lastHeartbeatMessage" : "",
			"syncSourceHost" : "mongo-0.mongo:27017",
			"syncSourceId" : 0,
			"infoMessage" : "",
			"configVersion" : 5,
			"configTerm" : 1
		},
		{
			"_id" : 2,
			"name" : "mongo-2.mongo:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 49,
			"optime" : {
				"ts" : Timestamp(1649644939, 1),
				"t" : NumberLong(1)
			},
			"optimeDurable" : {
				"ts" : Timestamp(1649644939, 1),
				"t" : NumberLong(1)
			},
			"optimeDate" : ISODate("2022-04-11T02:42:19Z"),
			"optimeDurableDate" : ISODate("2022-04-11T02:42:19Z"),
			"lastAppliedWallTime" : ISODate("2022-04-11T02:42:29.354Z"),
			"lastDurableWallTime" : ISODate("2022-04-11T02:42:19.353Z"),
			"lastHeartbeat" : ISODate("2022-04-11T02:42:28.444Z"),
			"lastHeartbeatRecv" : ISODate("2022-04-11T02:42:27.606Z"),
			"pingMs" : NumberLong(1),
			"lastHeartbeatMessage" : "",
			"syncSourceHost" : "mongo-1.mongo:27017",
			"syncSourceId" : 1,
			"infoMessage" : "",
			"configVersion" : 5,
			"configTerm" : 1
		}
	],
	"ok" : 1,
	"$clusterTime" : {
		"clusterTime" : Timestamp(1649644949, 1),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	},
	"operationTime" : Timestamp(1649644949, 1)
}

```

### reference
https://deeptiman.medium.com/mongodb-statefulset-in-kubernetes-87c2f5974821
