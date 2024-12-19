# Elastic Search Complete guide - Sharding, Scalability & Replicatoin

## Sharding

The ability to scale document storage. it is a way to fit large indices onto nodes.
It has improved performance as parallezied queries increase throughput of index.

Sharding splits indices to smaller peices, thus increas the number of documents an index can store.

Split API can be used to increse the number of shards
Trim API can be used to decrease the number of shards.

Deciding on number of shards depends on many factors, such as:-

* Number of nodes within a cluster
* Capacity of nodes
* number of indices and their sizes
* number of queries run against the indices
* and more

## Replication

A fault tollerant failover mechanism and enabled by default. Ensures high availability for indices.
A side benefit of increase throughput.

It is configured at the index level.
It works by creating copies of shards, reffered to as replica shards.
A replicated shard is called primary shard. Together they called replication group
Replica shards are not stored in the primary shard node.
Snapshots can take backups of specific indices or the whole cluster.

## Managing Multiple nodes

### Check current state of cluster

Check the current cluster with the cluster API `GET /_cluster/health`. It indicates that there is one node and yellow status.
This is due to the previously created index 'pages' has a replica shard that is not assigned to a node.
The state of the shard can be viewed by running the `GET/_cat/shards?v`. observe that the 'pages' index with the prirep r is UNASSIGNED.

### Creating multiple nodes

We are going to create 2 more nodes

#### Creating second node

Extract the archive es file twice and name them accordingly, these will be our second and third nodes (do not copy the directory of current node!!).
Open the config/elasticsearch.yml. Change the node.name value to a meaningfull one (e.g second-node).

Create an enrollment token for each nodes to join the cluster.
run the token enrollment bat file on the initial node directory `bin\elasticsearch-create-enrollment-token --scope node`.
Copy the token and start the second node `bin\elasticsearch --enrollment-token eyJ2ZXIiOiI4LjE0LjAiLCJhZHIiOlsiMTcyLjE4LjM2Ljg0OjkyMDAiXSwiZmdyIjoiZjY4NGNlNWIyNzg0YzZiZDg1MjM5NmUxNjk0NmM2Y2E2MzIyOGZmYzlhYzcwZjhiZDc2MGQ1OTc3NmU2MzE4MyIsImtleSI6ImRMdWo1cElCOGpibTJxTTJQeTl0OmQ0UExmdFQ1VHUtZUNjQVNQTnM2VmcifQ==`

Check the status in Kibana, Observe that the cluster status is green and the number of nodes is 2.
the replica shard is now assigned to the second-node and started.
Also note that the system indices now have replica shard since the default configuration is to index.auto_expand_replicas.
This will automatically create replica shards as new nodes are created.

#### Creating third node

Take node that once third node is added. 2 nodes must run at anytime.
Repeat what was done for second node.

When a node is removed/added the shard are distributed automatically by ES, this distribution takes time.

## Node roles

### master

A node can be elected to be a master node and is responsible for performing cluster wide operation.

### Data

Enables a node to store data and allow performing queries such as search queries.

for large clusters it is good to have dedicated master role and disable their role to store data `node.data true|false`

### Ingest

Enables a node to run ingest pipelines `node.ingest true|false`
These are series of steps/preprocesses to perform document indexing. It is a simplified version of logstash directly within elasticsearch.

### Machine learning

`node.ml: true|false` and `xpack.ml.enabled: true|false`.

### Coordination

Set by default where other roles are set to false. It manages routing and coordination of queries. Every nodes implicitly have this role. A node with explici empty `node.roles` has this role (cannot be disabled).
It has 2 phases(scatter/gather).

### voting-only

`node.voting-only: true|false`








