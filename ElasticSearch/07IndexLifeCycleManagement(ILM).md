# Inde Lifecycle management



## ILM Scenario: Multiple phases

We will review an example of an index lifecycle going through hot, warm, cold and delete phases. It involves policy creation, index template created with the lifecycle setting and index created with an alias to support the indexes created during the lifecycle.

### Creating policy

```c#
PUT /_ilm/policy/test-ilm
{
  "policy": {
    "phases": {
      "hot": {
        "min_age": "0ms",
        "action": {
          "set_priority": { "priority": 100 },
          "rollover": {
            "max_age": "5m",
            "max_primary_shard_size": "50gb"
          }
        }
      },
      "warm": {
        "min_age": "0ms",
        "action": {
          "set_priority": { "priority": 50 }
        }
      },
      "cold": {
        "min_age": "0ms",
        "action": {
          "set_priority": { "priority": 0}
        }
      }
      "delete": {
        "min_age": "20m",
        "action": {
          "delete" : { "delete_searchable_snapshot": true }
        }
      }
    }
  }
}
```

### Index template

```c#
PUT /_template/accounts
{
  "index_patterns": ["test-index-*"],
  "template": {
    "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 0,
        "lifecycle": {
          "lifecycle_name": "test-ilm",
          "rollover_alias": "test-index"
        }
    },
    "mappings": {
      "properties" {
        "@timestamp": { "type": "date" },
        "field": "text"
      }
    }
  }
}
```

### Create index with alias then index docs

```c#
PUT /index-000000
{
  "aliases": { "test-index": { "is_write_index": true } }
}

// index documents
PUT test-index/_doc/1
{
  "@timestamp" : "2024-12-04T16:26:00.000Z",
  "field":"test data"
}

PUT test-index/_doc/2
{
  "@timestamp" : "2024-12-04T16:58:00.000Z",
  "field":"Another Data"
}
```

### Verify created objects

```c#
GET /_ilm/policy/test-ilm

GET /_index_template/test_ilm_tpl

GET test-index-000000
GET /_alias/test-index

GET /test-index-000000/_search
{ "query": { "match_all": {} } }

GET /test-index/_search
{ "query": { "match_all": {} } }

```


### observe lifecycle

`GET test-index/_ilm/explain?filter_path=*.*.age,*.*.phase`

### Cleanup

```c#
DELETE /_ilm/policy/test-ilm
DELETE /_index_template/test_ilm_tpl
DELETE /test-index-000000
DELETE /test-index-000001
```

## ILM Scenario: Delete cycle

### Create a plicy 'timeseries_policy'

```c#
PUT /_ilm/policy/timeseries_policy
{
    "policy": {
        "phases": {
            "hot": {
              "actions": {
                "rollover": {
                  "max_primary_shard_size": "50g",
                  "max_age": "30d"
                }
              }
            },
            "delete": {
                "min_age": "90d",
                "actions": { "delete": {} }
            }
        }
    }
}

GET /_ilm/policy/timeseries_policy
```

### Create an index template 'timeseries_template' with 'timeseries_policy' lifecycle

```c#
PUT /_index_template/timeseries_template
{
    "index_patterns": ["timeseries-*"],
    "template": {
        "settings": {
            "number_of_replicas": 0,
            "number_of_shards": 1,
            "index.lifecycle.name": "timeseries_policy",
            "index.lifecycle.rollover_alias": "timeseries"
        }
    }
}
GET /_index_template/timeseries_template
```

### Create an index with alias

Matches the index_pattern specified in the index template. Alias must match the rollover_alias in the index template

```c#
PUT /timeseries-000001
{
    "aliases": {
        "timeseries": { "is_write_index": true }
    }
}
```

### Index some documents

```c#
POST /_bulk
{ "index": { "_index": "timeseries-000001" } }
{ "message": "Logged a request 0", "@timestamp": "1591890612" }
{ "index": { "_index": "timeseries-000001" } }
{ "message": "Logged a request 1", "@timestamp": "1591890613" }
{ "index": { "_index": "timeseries-000001" } }
{ "message": "Logged a request 2", "@timestamp": "1591890614" }
{ "index": { "_index": "timeseries-000001" } }
{ "message": "Logged a request 3", "@timestamp": "1591890615" }

GET /timeseries-000001/_search
{ "query": { "match_all": {} } }

GET _cat/indices/time*?v
GET _alias/timeseries
```


### Force a rollover

`POST timeseries/_rollover`

### Observe changes

`GET timeseries/_ilm/explain?filter_path=*.*.age,*.*.phase`

## Define an index template that creates a new data stream

### Create ILM Policy

```c#
PUT _ilm/policy/ds_policy
{
  "policy": {
    "phases": {
      "hot": {
        "actions": {
          "rollover": {
            "max_primary_shard_size": "50GB",
            "max_age": "30d"
          }
        }
      },
      "delete": {
        "min_age": "90d",
        "actions": { "delete": {} }
      }
    }
  }
}
```

### Create component tempalates

#### Component template for mapping

```c#
PUT _component_template/my-mappings
{
  "template": {
    "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date",
          "format": "date_optional_time||epoch_millis"
        },
        "message": { "type": "wildcard" }
      }
    }
  },
  "_meta": {
    "description": "Mappings for @timestamp and message fields",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}
```

#### Component template for settings

```c#
PUT _component_template/my-settings
{
  "template": {
    "settings": {
      "index.lifecycle.name": "ds-policy"
    }
  },
  "_meta": {
    "description": "Settings for ILM",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}
```

### 3. Create the combined index template

```c#
PUT _index_template/my-component-index-template
{
  "index_patterns": ["my-data-stream*"],
  "data_stream": { },
  "composed_of": [
    "my-mappings",
    "my-settings"
  ],
  "priority": 500,
  "_meta": {
    "description": "Template for my time series data",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}
```

### Create the data stream

```c#
POST my-data-stream/_doc
{
  "@timestamp": "2099-05-06T16:21:15.000Z",
  "message": "192.0.2.42 - - [06/May/2099:16:21:15 +0000] \"GET /images/bg.jpg HTTP/1.0\" 200 24736"
}
```

### view document count

`GET _cat/indices/.ds-my-data-stream-2021.06.27-000001?v`