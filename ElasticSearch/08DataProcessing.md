# Data processing


## Define and use mapping and analyzers to process data

### Create explicit mapping

Create a new index mapping called `henry4` that matches the following requirements:

* speaker: keyword
* line_id: keyword and not aggregateable
* speech_number: integer

Write a custom analyzer that changes the name of PRINCE HENRY to WAYWARD PRINCE HAL in the speaker field, add this to a new index called henry4_hal

* Create a new index,
* with a mapping on the speaker field
* that utilises an analyser to rename the princes name if it matches.

```c#
PUT /henry4
{
  "settings": {
    "number_of_replicas: 0
  },
  "mapping": {
    "properties": {
      "speaker": {"type": "keyword"},
      "line_id": { "type": "keyword", "doc_values": false },
      "speech_number: {"type": "integer"}
    }
  }
}
```

## Reindex from another index

```c#
POST /_reindex
{
  "source": {
    "index": "shakespeare",
    "query": { "term": { "play_name": "henry IV" }}
  },
  "dest": { "index": "henry4" }

}

GET /henry4/_search
{ "query": { "match_all": {} } }
```

### Test analyzer

```c#
POST /_analyze
{
  "char_filter": {
    "type": "pattern_replace",
      "pattern": "PRINCE HENRY",
    "replacement": "WAYWARD PRINCE HAL"
  },
  "text": [
    "PRINCE WILLIAM",
    "PRINCE HENRY",
    "PRINCE HARRY",
  ]
}
```

### Create index 'henry4_hal' with mapping and analyzer

```c#
PUT /henry4_hal
{
  "settings": {
    "number_of_replicas": 0,
    "analysis": {
      "analyzer": {
        "wayward_son_analyser": {
          "type": "custom",
          "tokenizer": "standard",
          "char_filter": ["rename_filter"]
        }
      },
      "char_filter": {
        "rename_filter": {
          "type": "pattern_repliace",
          "pattern": "PRINCE HENRY",
          "replacement": "WAYWARD PRINCE HAL"
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "speaker": {
        "type": "text",
        "fields" {
          "keyword": { "type": "keyword", "ignore_above": 256 }
        },
        "analyzer": "wayward_son_analyser"
      },
      "line_id": { "type": "integer" },
      "speech_number": { "type": "integer" }
    }
  }
}
```

### Reindex documents

```c#
POST /_reindex
{
  "source": {
    "index": "shakespeare",
    "query": { "term": { "play_name": "Henry IV" } }
  },
  "dest": { "index": "henry4_hal"}
}

GET henry4_hal/_search
{ "query": { "term": { "speaker": "HAL" } } }
```

## Use the Reindex API and Update By Query API to reindex and/or update documents

### Multiple reindexing based on condition

* Reindex the accounts-raw index into accounts-2021.
* Then reindex accounts-2021 into accounts-female index where only the female account holders are present.

```c#
POST /_reindex
{
  "source": { "index": "accounts-raw" },
  "dest": { "index": "accounts-2021" }
}

POST /_reindex
{
  "source": {
    "index": "accounts-2021",
    "query": { "term": { "gender.keyword": "F" }
    }
  },
  "dest": { "index": "accounts-female" }
}

GET accounts-female/_count?filter_path=count

GET /accounts-female/_search?filter_path=*.*.*.gender
```

### Update docs by query

Give all female account holders in accounts-2021 a 25% bonus increase on their balance.

```c#
// get 2 example and note down their balance to check later
GET /accounts-raw/_search?q=gender:F&size=2
GET /accounts-raw/_doc/_mget?filter_path=*.*.balance
{ "ids" : ["13", "25"] }


// update to increae balance to 25%
POST /accounts_female/_update_by_query
{
  "script": {
    "source": "ctx._source.balance=ctx._source.balance*1.25",
    "lang": "painless"
  },
  "query": { "term": { "gender.keyword": "F" } }
}

// check balance again
GET /accounts-2021/_doc/_mget?filter_path=*.*.balance
```

## Configure an index so that it properly maintains the relationships of nested arrays of objects


### Create the mapping

```c#
PUT henry4_r
{
  "mappings": {
    "properties": {
      "relationship": { "type": "nested" }
    }
  }
}
```

Query all people that are a foe of KING HENRY IV

```c#
GET henry4_r/_search
{
  "query": {
    "nested": {
      "path": "relationship",
      "query": {
        "bool": {
          "must": [
            { "match": { "relationship.name": "KING HENRY IV" }},
            { "match": { "relationship.type":  "foe" }}
          ]
        }
      }
    }
  }
}
```

Query friends of FALSTAFF

```C#
GET henry4_r/_search?filter_path=*.*.*.name
{
  "query": {
    "nested": {
      "path": "relationship",
      "query": {
        "bool": {
          "must": [
            { "match": { "relationship.name": "FALSTAFF" }},
            { "match": { "relationship.type":  "friend" }}
          ]
        }
      }
    }
  }
}
```
