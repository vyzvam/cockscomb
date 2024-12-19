# ElasticSearch Cross Cluster

## Configure for cross cluster search (CCS)

ref: <https://www.elastic.co/guide/en/elasticsearch/reference/8.1/modules-cross-cluster-search.html>

### Prerequisites

* It requires remote clusters
* Has version compatibility
* The local coordinating node must have the `remote_cluster_client` node role.

### Remote cluster setup

```c#
PUT _cluster/settings
{
  "persistent": {
    "cluster": {
      "remote": {
        "cluster_one": {
          "seeds": [ "127.0.0.1:9300" ]
        },
        "cluster_two": {
          "seeds": [ "127.0.0.1:9301" ]
        },
        "cluster_three": {
          "seeds": [ "127.0.0.1:9302" ]
        }
      }
    }
  }
}

GET _cluster/settings?pretty&flat_settings
```

### Searching remote clusters

```c#

GET cluster_one:my-index-000001/_count

// searching single remote cluster
GET /cluster_one:my-index-000001/_search
{
  "query": {
    "match": { "user.id": "kimchy" }
  },
  "_source": ["user.id", "message", "http.response.status_code"]
}

// Searching multiple remote clusters
GET /my-index-000001,cluster_one:my-index-000001,cluster_two:my-index-000001/_search
{
  "query": {
    "match": { "user.id": "kimchy" }
  },
  "_source": ["user.id", "message", "http.response.status_code"]
}

// Optional remote clusters
PUT _cluster/settings
{
  "persistent": { "cluster.remote.cluster_two.skip_unavailable": true }
}
```

## Cross cluster replication (CCR)

ref: <https://www.elastic.co/guide/en/elasticsearch/reference/8.1/xpack-ccr.html>

With cross-cluster replication, you can replicate indices across clusters to:

* Continue handling search requests in the event of a ***datacenter outage***
* Prevent search volume from ***impacting indexing throughput***
* Reduce ***search latency*** by processing search requests in ***geo-proximity*** to the user

* Cross-cluster replication uses an ***active-passive*** model
* You index to a leader index, and the data is replicated to one or more read-only follower indices
* When the leader index receives writes, the follower indices pull changes from the leader index on the remote cluster
* Configure the remote cluster that contains the leader index then add a follower index to the cluster
* You can manually create follower indices, or configure auto-follow patterns to automatically create follower indices for new time series indices.

Configure cross-cluster replication clusters in a uni-directional or bi-directional setup:

* In a uni-directional configuration, one cluster contains only leader indices, and the other cluster contains only follower indices
* In a uni-directional configuration, the cluster containing follower indices must be running the same or newer version of Elasticsearch as the remote cluster. If newer, the versions must also be compatible as outlined in the doc.
* In a bi-directional configuration, each cluster contains both leader and follower indices

### Multi-cluster architecture

Use cross-cluster replication to construct several multi-cluster architectures within the Elastic Stack:

* ***Disaster recovery*** in case a primary cluster fails, with a secondary cluster serving as a hot backup
* ***Data locality*** to maintain multiple copies of the dataset close to the application servers (and users), and reduce costly latency
* ***Centralized reporting*** for minimizing network traffic and latency in querying multiple geo-distributed Elasticsearch clusters, or for preventing search load from interfering with indexing by offloading search to a secondary cluster

### Setup CCR

#### CCR Prerequisites

* have `manage` cluster privilege in local cluster
* A license on both clusters that includes CCR
* An index on the remote cluster that contains the data to be replicated
* In local cluster, all nodes with the `master node` role must have the `remote_cluster_client` role
* Local cluster, at least one node with the `data node` & 'remote_cluster_cluent` roles.

#### Connect to remote cluster

To replicate an index on a remote cluster to a local cluster, configure the remote cluster as remote on local cluster.

```c#
PUT /_cluster/settings
{
  "persistent" : {
    "cluster" : {
      "remote" : {
        "leader" : {
          "seeds" : [ "127.0.0.1:9300" ]
        }
      }
    }
  }
}

GET /_remote/info
```

#### Enable soft deletes on leader indices

***Enable soft delete on the remote cluster***. To follow an index, it must have been created with soft deletes enabled. If not, reindex it and use the new index as the leader index. Soft deletes are enabled by default.

#### Configure privileges for CCR

The cross-cluster replication role on the remote cluster containing the leader index requires the `read_ccr` cluster privilege, and `monitor` and `read` privileges on the leader index.

```c#
POST /_security/role/remote-replication
{
  "cluster": [ "read_ccr" ],
  "indices": [
    {
      "names": [ "leader-index-name" ],
      "privileges": [ "monitor", "read" ]
    }
  ]
}
```

The remote-replication role on the local clustar containing the follower index requires the manage_ccr cluster privilege, and monitor, read, write, and manage_follow_index privileges on the follower index.

```c#
POST /_security/role/remote-replication
{
  "cluster": [ "manage_ccr" ],
  "indices": [
    {
      "names": [ "follower-index-name" ],
      "privileges": [ "monitor", "read", "write", "manage_follow_index" ]
    }
  ]
}
```

Create a user on the local cluster and assign the remote-replication role.

```c#
POST /_security/user/cross-cluster-user
{
  "password" : "l0ng-r4nd0m-p@ssw0rd",
  "roles" : [ "remote-replication" ]
}
```

#### Create a follower index & replicate a specific index

```c#
PUT /server-metrics-follower/_ccr/follow?wait_for_active_shards=1
{
  "remote_cluster" : "leader",
  "leader_index" : "server-metrics"
}
```

#### Create an auto-follow pattern to replicate time series indices

Use auto-follow patterns to automatically create new followers for rolling time series indices. Whenever the name of a new index on the remote cluster matches the auto-follow pattern, a corresponding follower index is added to the local cluster.

An auto-follow pattern specifies the remote cluster you want to replicate from, and one or more index patterns that specify the rolling time series indices you want to replicate.

```c#
PUT /_ccr/auto_follow/beats
{
  "remote_cluster" : "leader",
  "leader_index_patterns" : [ "metricbeat-*", "packetbeat-*" ],
  "follow_index_pattern" : "{{leader_index}}-copy"
}
```
