# Data Management

## Creating index

Example

```c#
PUT /accounts
{
  "number_of_shards": 1,
  "number_of_replicas": 0
}
```

## Index template

```c#
PUT /_template/accounts
{
  "index_patterns": ["accounts-*"],
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "_source": { "enabled": false },
    "properties": {
      "account_number": { "type": "integer"},
      "first_name": { "type": "keyword"},
      "last_name": { "type": "keyword"},
      "age": { "type": "integer"},
      "gender": { "type": "keyword"},
      "address": { "type": "text"},
      "email": { "type": "keyword"},
      "employer": { "type": "text", "field": { "keyword": { "type": "keyword"}} }
    }
  }
}

// verify mapping
POST /accounts-new/_search?filter_path=hits.total.value
{
  "query": {
    "match": { "employee": "Zork" }
  }
}
```

## Define and use a dynamic template that satisfies a given set of requirements

### Dynamic field mapping

### Dynamic templates

