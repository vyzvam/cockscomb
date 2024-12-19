# Snapshot & Restore

## Backup/Restore cluster or indices

* Use Kibana
* Snapshot allowed only on a running cluster with an elected master node
* Snapshot repository must be registered and available to the cluster
* Required permission
  * **Cluster privilege**: monitor, manage_slm, cluster:admin/snapshot, cluster:admin/repository
  * **Index Privilege**: all on the monitor index
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

## Creating a snapshot

```c#
// Make sure the `path.repo` is set
// Check current setting
GET /_nodes?pretty&filter_path=nodes.*.settings.path

// if it is not available add the setting in `config/elasticsearch.yml`
path.repo: "C:\\elk\\es01\\repo"
```

### Register snapshot (creating a repo)

```c#
PUT /_snapshot/testbackup
{
    "type": "fs",
    "settings": {
        "location" : "C:\\elk\\es01\\repo",
        "compress": true
    }
}
```

### Verify & analyze snapshot

```c#
GET /_snapshot/_all
GET /_snapshot/testbackup
POST /_snapshot/testbackup/_verify
POST /_snapshot/testbackup/_analyze?blob_count=10&max_blob_size=1mb&timeout=120s
POST /_snapshot/testbackup/_verify_integrity
```

### Start and check snapshot job

```c#
PUT /_snapshot/testbackup/%3Cproducts-snapshot-%7Bnow%2Fd%7D%3E
{
  "indices": "products",
  "ignore_unavailable": true,
  "include_global_state": false
}

GET /_snapshot/testbackup/_all
GET /_snapshot/testbackup/%3Cproducts-snapshot-%7Bnow%2Fd%7D%3E
```

Cluster settings can be included by setting `"include_globa-state": true`.
Or these settings can be captured manuall by calling the settings API `GET _cluster/settings?pretty&flat_settings&filter_path=persistent`

### Restore

```c#
POST /_snapshot/testbackup/products-snapshot-2021.05.13/_restore
{
  "indices": "products",
  "ignore_unavailable": true,
  "include_global_state": true,
  "rename_pattern": "(.+)",
  "rename_replacement": "restored_index_$1"
}

GET _cat/indices/*products
```

### Cleanup

```c#
DELETE /_snapshot/testbackup/products-snapshot-2021.05.13
POST /_snapshot/testbackup/_cleanup
DELETE /_snapshot/testbackup
```

## Backup/Restore cluster configuration

Done by specifying the `include_global_state:true`.
Alternately can be extracted from the settings API
`GET /_cluster/settings?pretty&flat_settings&filter_path=persistent`

## Backup specific feature state

`GET /_features`

To include a specific feature state in a snapshot, specify the feature name in the feature_states array.

## Backup security configurations

### File based

Security features are configured using the `xpack.security` namespace inside the elasticsearch.yml and elasticsearch.keystore files.
In addition there are several other extra configuration files inside the same ES_PATH_CONF directory. These files define roles and role mappings and configure the file realm.

## Index based

```c#
// snapshot the `.security` index alias.
GET /_snapshot/my_backup`
GET /_snapshot/my_backup/snapshot_1

bin/elasticsearch-users useradd restore_user -p password -r superuser`

DELETE /.security-*"`

```c#
POST /_snapshot/my_backup/snapshot_1/_restore
{
    "indices": ".security-*",
    "include_global_state": true
}
```

## Searchable snapshots

* Use snapshots to search infrequently accessed and read-only data in a very cost-effective fashion
* The cold and frozen data tiers use searchable snapshots to reduce your storage and operating costs
* Eliminate the need for replica shards, potentially halving the local storage needed to search your data
* Rely on the same snapshot mechanism you already use for backups and have minimal impact on your snapshot repository storage costs

### Example

`xpack.searchable.snapshot.shared_cache.size=100mb`

Create snapshot repo

```c#
PUT /_snapshot/my_snapshots
{
    "type": "fs",
    "settings": {
        "location": "/tmp/snapshots",
        "compress": true
    }
}

// check repo
GET /_snapshot/my_snapshots
```

Create snapshot

```c#
PUT /_snapshot/my_snapshots/%3Cecomm-snapshot-%7Bnow%2Fd%7D%3E
{
  "indices": "products",
  "ignore_unavailable": true,
  "include_global_state": false
}

// list snapshots
GET _snapshot/my_snapshots/products*
```

recover snapshot into local cache by mounting it

```c#
POST _snapshot/my_snapshots/ecomm-snapshot-2021.10.07/_mount?storage=shared_cache
{
  "index" : "products",
  "renamed_index": "mounted-products"
}

// test it
GET _cat/indices/mounted-products?v

GET _cat/count/mounted-products
GET mounted-products/_count
GET mounted-products/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

Cleanup

```c#
POST /mounted-products/_searchable_snapshots/cache/clear
DELETE mounted-products
```


