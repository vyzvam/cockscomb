# Cluster Management

## General

CAT API `_cat` = Compact & aligned text API

## Troubleshooting cluster health

```c#
GET /cluster/_health?v
GET /_cat/health?v
GET /_cat/nodes?v
GET /_cat/indices?
GET /_cat/indices?v&health=yellow
```

```c#
// creating an index by specifying number of shards and replicas
PUT products
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 2
  }
}

GET /_cat/shards/products?v
```

Note that in order for the cluster to be healthy `green`, the shards needs to be allocated to distint nodes, i.e if number of shards is 2, you must have 2 nodes running for the cluster to be healthy, either add nodes accordingly or adjust / reduce the number of shards.

```c#
GET /cluster/allocation/explain
{
    "index": "products",
    "shard": 0,
    "primary": true
}

PUT products/_settings
{
    "number_of_replicas": 1,
}
```

Default number of shard is 1, limited to 1024 per index

Per node limitation:

* 1000 non-frozen data nodes
* 3000 frozen data nodes
* http request body size < 100MB

## Backup/Restore cluster or indices

* Use Kibana
* Required permission
    * Cluster privilege: monitor, manage_slm, cluster:admin/snapshot, cluster:admin/repository
    * Index Privilege: all on the monitor index
* Snapshot allowed only on a running cluster with an elected master node
* Snapshot repository must be registered and available to the cluster
* Cluster's global metadata must be readable.
* When including index in snapshot, it and it's metada must be readable.
* Ensure there are no cluster or index blocks that prevent read access
* Snapshot names must be unique within its repo
* Snapshots are automatically deduplicated. frequent snapshots can be taken with little impact to storage overhead.
* Each snapshot is logically independent. Snapshot can be deleted without affecting other snapshots.
* Taking snapshot can temporarily pause shard allocation
* Taking a snapshot doesn’t block indexing or other requests. Snapshot won’t include changes made after the snapshot process starts.
* The `snapshot.max_concurrent_operations` cluster setting limits the maximum number of concurrent snapshot operations.
* Including a data stream in a snapshot, it includes the stream’s backing indices and metadata.