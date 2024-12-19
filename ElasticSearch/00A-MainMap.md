---
title: Elastic Search
markmap:
  colorFreezeLevel: 2
---

## Infrastructure

### Health Check

```c#
GET /_cluster/health
GET /_cat/health
GET /_cat/nodes?v

GET /_cat/indices?v
GET /_cat/indices?v&health=yellow

GET /_cat/shards
GET /_cat/shards?index={indexname}

GET _cluster/allocation/explain
{
  "index": "{index_name}",
  "primary": true,
  "shard": 0
}
```

### Index creation & update

```c#
PUT /myindex
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}

PUT /myindex/_settings
{ "number_of_replicas": 1 }
```

### Backup & Restore

#### Backup Reposity

```c#
// Make sure the `path.repo` is set
// Check current setting
GET /_nodes?pretty&filter_path=nodes.*.settings.path

// if it is not available add the setting in `config/elasticsearch.yml`
path.repo: "C:\\elk\\es01\\repo"

// Create a repository / Register snapshot location
PUT /_snapshot/testbackup
{
    "type": "fs",
    "settings": {
        "location" : "C:\\elk\\es01\\repo",
        "compress": true
    }
}
```

#### Verify & analyze snapshot

```c#
GET /_snapshot/_all
GET /_snapshot/testbackup
POST /_snapshot/testbackup/_verify
POST /_snapshot/testbackup/_analyze?blob_count=10&max_blob_size=1mb&timeout=120s
POST /_snapshot/testbackup/_verify_integrity
```

#### Start and check snapshot job

```c#
PUT /_snapshot/my_test_backup/%3Cshakespeare-snap-%7Bnow%2Fd%7D%3E
{
  "indices": "shakespeare",
  "ignore_unavailable": true,
  "include_global_state": true
}

GET /_snapshot/my_test_backup/_all


// Cluster settings can be included by setting `"include_global-state": true`.
// Or these settings can be captured manuall by calling the settings API
GET _cluster/settings?pretty&flat_settings&filter_path=persistentk
```

#### Backup specific feature state

```c#
GET /_features

To include a specific feature state in a snapshot, specify the feature name in the feature_states array.
```

#### Restore snapshot

```c#
PUT /_snapshot/testbackup/shakespeare-snap-2024-12-17/_restore
{
  "indices": "shakespeare",
  "ignore_unavailable": true,
  "include_global_state": true,
  "rename_pattern": "(.+)",
  "rename_replacement": "restored_index_$1"
}

GET _cat/indices/*shakespeare
```

#### Security settings

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

#### Searchable snapshots

```c#
POST _snapshot/my_snapshots/shakespreare-snapshot-2021.10.07/_mount?storage=shared_cache
{
  "index" : "shakespeare",
  "renamed_index": "mounted-shakespeare"
}

// test it
GET _cat/indices/mounted-shakespeare?v

GET _cat/count/mounted-shakespeare
GET mounted-shakespeare/_count
GET mounted-shakespeare/_search
{
  "size": 5,
  "query": { "match_all": {} }
}
```

### Index life-cycle management

#### Creat ILM Policy

```c#
PUT /_ilm/policy/test-ilm
{
    "policy": {
        "phases": {
            "hot": {
                "min_age": "0ms",
                "actions": {
                    "set_priority": { "priority": 100 },
                    "rollover": {
                        "max_age": "5m",
                        "max_primary_shard_size": "50gb"
                    }
                }
            },
            "warm": {
                "min_age": "5m",
                "actions": {
                    "set_priority": { "priority": 50}
                }
            },
            "cold": {
                "min_age": "5m",
                "actions": {
                    "set_priority": { "priority": 0}
                }
            },
            "delete": {
                "min_age": "5m",
                "actions": {
                    "delete": {
                        "delete_searchable_snapshot": true
                    }
                }
            }
        }
    }
}
```

#### Create index template

```c#
PUT /_index_template/test_ilm_tpl
{
    "index_patterns": ["test-index-*"],
    "template": {
        "settings": {
            "number_of_replicas": 0,
            "number_of_shards": 1,
            "lifecycle": {
                "name": "test-ilm",
                "rollover_alias": "test-index"
            }
        },
        "mappings": {
            "properties": {
                "@timestamp": { "type": "date"},
                "field": {"type": "text"}
            }
        }
    },
    "composed_of": []
}
```

#### Create index with alias

```c#
PUT /test-index-00000
{
    "aliases": {
      "test-index": {
        "is_write_index": true
      }
    }
}

// add documents
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

#### Observe rollover

```c#
GET test-index/_ilm/explain?filter_path=*.*.age,*.*.phase
```

#### With component template for data stream

```c#
// Create ILM Policy
PUT /_ilm/policy/ds_policy
{
  "policy": {
    "stages": {
      "hot": {
        "actions": {
          "rollover": {
            "max_age": "30d",
            "max_primary_shard_size": "50gb"
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

// Create component templates
// Component for mapping
PUT /_component_template/my-mappings
{
  "template": {
    "mappings": {
      "properties": {
        "@timestamp": {
          "type": "date"
          "format": "date_optional_time|epoch_millis"
        },
        "message": "wildcard"
      }
    }
  },
  "_meta": {
    "description": "Mappings for @timestamp and message fields",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}

//  Component for settings
PUT /_component_template/my-settings
{
  "template": {
    "settings": { "index.lifecycle.name": "ds-policy" }
  },
  "_meta": {
    "description": "Settings for ILM",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}

//  Create index template & associate components
PUT _index_template/my-component-index-template
{
  "index_patterns": ["my-data-stream*"],
  "data_stream": { },
  "composed_of": [ "my-mappings", "my-settings" ],
  "priority": 500,
  "_meta": {
    "description": "Template for my time series data",
    "my-custom-meta-field": "More arbitrary metadata"
  }
}

//  Create index (data stream)
POST my-data-stream/_doc
{
  "@timestamp": "2099-05-06T16:21:15.000Z",
  "message": "192.0.2.42 - - [06/May/2099:16:21:15 +0000] \"GET /images/bg.jpg HTTP/1.0\" 200 24736"
}

GET _cat/indices/.ds-my-data-stream-2021.06.27-000001?v
```

### Cross cluster replication

* Enable license in stack management
* Add remote cluster in stack management
* Setup cross cluster replication
* Create auto-follow pattern

### Configure cross cluster search

```c#
PUT _cluster/settings
{
  "persistent": {
    "cluster": {
      "remote": {
        "cluster_one": {
          "seeds": [
            "10.0.0.1:9300"
          ]
        },
        "cluster_two": {
          "seeds": [
            "2.0.0.1:9300"
          ]
        },
        "cluster_three": {
          "seeds": [
            "3.0.0.1:9300"
          ]
        }
      }
    }
  }
}
```




## Mapping

### Field mapping

#### Dynamic Mapping

```c#
// ElasticSearwch dynamically handles the type for each field
```

#### Explicit Mapping

```c#
PUT /person
{
  "_mapping": {
    "properties": {
      "first.name": {"type": "keyword"},
      "last.name": {"type": "keyword"},
      "age": {"type": "integer"},
      "email": {"type": "keyword"}
      "occupation": {"type": "text"}
      "birthdate": {"type": "date"}
    }
  }
}

GET /person/_mapping
GET /person/_mapping/field/first.name
PUT /review/_mapping
{ "properties": { "death_at": "date" } }
```

### Index Template

```c#
PUT /_index_template/tpl_person
{
  "index_patterns": ["person_*"],
  "template": {
    "mapping": {
      "properties": {
        "first.name": {"type": "keyword"},
        "last.name": {"type": "keyword"},
        "age": {"type": "integer"},
        "email": {"type": "keyword"}
        "occupation": {"type": "text"}
        "birthdate": {"type": "date"}
      }
    }
  }
}

GET /_index_template/tpl_person
DELETE /_index_template/tpl_person

// Patterns to avoid
// logs-*-*
// metrics-*-*
// synthetics-*-*
// profiling-*-*
```

### Dynamic Template

```c#
PUT /person
{
  "mapping": {
    "dynamic": true|false|strict, // disable dynamic mapping, must provide explicitly
    "numeric_detection": true,
    "date_detection": false
  }
}

PUT /person
{
    "mappings": {
        "dynamic_templates": [
            {
                "integers": {
                    "match_mapping_type": "long",
                    "mapping": { "type": "integer" }
                }
            }
        ]
    }
}

// To not index any fields from person index
PUT /person
{
    "mapping": {
        "dynamic_templates": {
            "no_doc_values": {
                "match_mapping_type": "*",
                "mapping": {
                    "type": "(dynamic_mapping)",
                    "index": false
                }
            }
        }
    }
}
```

## Analyzers

### Character filter

### Tokenizers

### Token Filters

## Data Processing

### Reindexing

#### Basic reindexing

```c#
POST /_reindex
{
  "source": {"index": "employee"},
  "dest": {"index": "managers"}
}
```

#### Reindex with ingest pipeline

```c#
POST /_reindex
{
  "source": {"index": "employee"},
  "dest": {
    "index": "managers",
    "pipeline": "pipeline_manager_filter_pipeline"
  }
}
```

#### Reindex with query

```c#
POST /_reindex
{
  "source": {
    "index": "employee",
    "query": {
      "term": {
        "level": "management"
      }
    }
  },
  "dest": { "index": "managers" }
}
```

#### Reindex from multiple indexes

```c#
POST /_reindex
{
  "source": { "index": ["employee", "vendors"] },
  "dest": { "index": "managers" }
}
```

#### Reindex selected fields

```c#
POST /_reindex
{
  "source": {
    "index": "employee",
    "_source": ["name", "age"]
  },
  "dest": { "index": "managers" }
}
```

#### Reindex with script

```c#
POST /_reindex
{
  "source": {
    "index": "employee",
    "_source": ["name", "age"]
  },
  "dest": { "index": "managers" },

  "script": {
    "lang": "painless",
    "source": """
      if (ctx._source.salary <= 10000) { ctx._source.salary = ctx._source.salary*1.10 }) }
    """
  }
}
```

## Ingestion Pipeline

### Simulate pipeline

```c#
POST /_ingest/pipeline/_simulate
{
  "pipeline": {
    "processors": [
      {
        "lowercsae": { "field": "my-keyword-field"}
      }
    ]
  },
  "docs": [
    { "_source": { "my-keyword-field": "FOO" } },
    { "_source": { "my-keyword-field": "BAR" } }
  ]
}
```

### Create a pipeline

```c#
POST /_ingest/pipeline/my_pipeline
{
  "pipeline": {
    "processors": [
      {
        "lowercsae": { "field": "my-keyword-field"}
      }
    ]
  }
}

// test the pipeline
POST /_ingest/pipeline/my_pipeline/_simulate
{
  "docs": [
    { "_source": { "my-keyword-field": "FOO" } },
    { "_source": { "my-keyword-field": "BAR" } }
  ]
}
```

### Add pipeline to an index request

```c#
POST my-data-stream/_doc?pipeline=my-pipeline
{
  "@timestamp": "2099-03-07T11:04:05.000Z",
  "my-keyword-field": "foo"
}

PUT my-data-stream/_bulk?pipeline=my-pipeline
{ "create":{ } }
{ "@timestamp": "2099-03-07T11:04:06.000Z", "my-keyword-field": "foo" }
{ "create":{ } }
{ "@timestamp": "2099-03-07T11:04:07.000Z", "my-keyword-field": "bar" }
```

### Use with Update by query and reindex

```c#
POST my-data-stream/_update_by_query?pipeline=my-pipeline

POST _reindex
{
  "source": {
    "index": "my-data-stream"
  },
  "dest": {
    "index": "my-new-data-stream",
    "op_type": "create",
    "pipeline": "my-pipeline"
  }
}
```

### Handling failures

```c#
PUT _ingest/pipeline/my-pipeline
{
  "processors": [
    {
      "rename": {
        "description": "Rename 'provider' to 'cloud.provider'",
        "field": "provider",
        "target_field": "cloud.provider",
        "ignore_failure": true
      }
    }
  ]
}

PUT _ingest/pipeline/my-pipeline
{
  "processors": [
    {
      "rename": {
        "description": "Rename 'provider' to 'cloud.provider'",
        "field": "provider",
        "target_field": "cloud.provider",
        "on_failure": [
          {
            "set": {
              "description": "Set 'error.message'",
              "field": "error.message",
              "value": "Field 'provider' does not exist. Cannot rename to 'cloud.provider'",
              "override": false
            }
          }
        ]
      }
    }
  ]
}
```


## Search

### Text Search

### Term Search

### Bool Search

### Sorting & Aggregation

### Asynch Search

## Improving search results

### Result format

```c#
// YAML
GET /recipe/_search?format=yaml
{ "query": { "match": { "title": "pasta" } } }

// in terminal
GET /recipe/_search?pretty
{ "query": { "match": { "title": "pasta" } } }
```

### Filter path

```c#
GET /shakespeare/_search?filter_path=hits.total.value

GET /shakespeare/_search?filter_path=hits.hits.*.speaker

```

### Source filtering

```c#
// exclude source
GET /recipe/_search
{
    "_source": false
    "query": { "match": { "title": "pasta" } }
}

// specify fields
GET /recipe/_search
{
    "_source": "created"
    "query": { "match": { "title": "pasta" } }
}

GET /recipe/_search
{
    "_source": ["created", "ingredients.*", "review.content"]
    "query": { "match": { "title": "pasta" } }
}

GET /recipe/_search
{
    "_source": {
        "includes": "ingredients.*",
        "excludes": "ingredients.name"
    }
    "query": { "match": { "title": "pasta" } }
}
```

### Pagination

```c#
// total_pages = ceil(total_hits / page_size)
// to navigate pages
// from = ceil(total_hits * (page_size-1))

GET /recipe/_search?size=2
{
    "_source": false
    "query": { "match": { "title": "pasta" } }
}
// or
GET /recipe/_search
{
    "size": 2
    "_source": false
    "query": { "match": { "title": "pasta" } }
}


// with offset
GET /recipe/_search
{
    "size": 2,
    "from": 2
    "_source": false
    "query": { "match": { "title": "pasta" } }
}

### Slop

```c#
// slop is used to identity the distance between the words to adjust the proximity in the search
GET /recipes/_search
{
    "query": {
        "match_phrase": {
            "title": "spicy sauce",
            "slop": 2
        }
    }
}

// Get better results with relevance score for the search query by the proximity
GET /recipes/_search
{
    "query": {
        "bool": {
            "must": [
                {
                    "match": {
                        "title": { "query": "spicy sauce" }
                    }
                }
            ],
            "should": [
                {
                    "match_phrase": {
                        "title": {
                            "query": "spicy sauce",
                            "slop": 5
                        }
                    }
                }
            ]
        }
    }
}

```

### Handling typos (fuzzy)

```c#
GET /product/_search
{
    "query": {
        "match": {
            "name": {
                "query": "l0bster",
                "fuzziness": "auto" //max edit distance is 2
            }
        }
    }
}

// transpotiitons
GET /product/_search
{
    "query": {
        "match": {
            "name": {
                "query": "lvie",
                "fuzziness": 1,
                "fuzzy_transposition": false
            }
        }
    }
}
```

### Synonyms

```c#
PUT /synonyms
{
    "settings": {
      "analysis": {
        "filter": {
          "synonym_test": {
            "type": "synonym",
            "synonyms": [
                "awfull => terrible",
                "awesome => great, super",
                "elasticsearch, kibana, logstach => elk",
                "weird, strange"
            ]
          }
        },
        "analyzer": {
          "my_analyzer": {
            "tokenizer": "standard",
            "filter": ["lowercase", "synonym_test"]
          }
        }
      }
    },
    "mappings": {
      "properties": {
          "description": { "type": "text", "analyzer": "my_analyzer" }
      }
    }
}

POST /synonyms/_analyze
{ "analyzer": "my_analyzer", "text": "awesome" }

POST /synonyms/_analyze
{ "analyzer": "my_analyzer", "text": "Elasticsearch" }

POST /synonyms/_analyze { "analyzer": "my_analyzer", "text": "weird" }

POST /synonyms/_analyze
{
    "analyzer": "my_analyzer",
    "text": "Elasticsearch is awesome, but can also seem weird sometimes."
}
```

### Highlighing matches

```c#
GET /shakespeare/_search
{
  "query": {
    "match": { "text_entry": { "query": "Hamlet"} }
  },
  "highlight": {
    "pre_tags":  ["<STRONG>"],
    "post_tags": ["</STRONG>"],
    "fields": { "text_entry": {} }
  }
}

GET shakespeare/_search
{
    "query": {
        "match": { "text_entry":  "Hamlet" }
    },
    "highlight": {
        "fields":  {
          "text_entry": {
            "pre_tags":  ["<STRONG>"],
            "post_tags": ["</STRONG>"]
        }
      }
    }
}
```

### Using Alias

```c#
POST /_aliases
{
  "actions": [
    {
      "add": {
        "index": "shakespeare",
        "alias": "shakespeare-clone"
      }
    }
  ]
}

POST /_aliases
{
  "actions": {
    "add": {
      "index": "shakespeare",
      "alias": "shakespeare-othello",
      "filter": {
        "term": { "speaker": "OTHELLO" }
      }
    }
  }
}
```

### Search Template

#### Create a template

```c#
POST _scripts/get_lines
{
  "script": {
    "lang": "mustache",
    "source": {
      "query": {
        "bool": {
          "must": [
            {
              "term": { "play_name": "{{play_name}}" }
            },
            {
              "term": { "speaker": "{{ speaker }}" }
            }
          ]
        }
      }
    }
  }
}

GET /_scripts/get_lines

```

#### Use a template

```c#
GET shakespeare/_search/template?filter_path=hits.hits.*.text_entry
{
    "id": "get_lines",
    "params": {
        "play_name": "Cymbeline",
        "speaker" : "Attendant"
    }
}
```