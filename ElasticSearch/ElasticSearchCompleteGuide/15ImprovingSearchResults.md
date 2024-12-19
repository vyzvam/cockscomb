# Elastic Search Complete guide - Improving search results


## Proximity Searches

```c#
PUT /proximity/1
{
    "title": "Spicy Sauce"
}

PUT /proximity/2
{
    "title": "Spicy Tomato Sauce"
}

PUT /proximity/3
{
    "title": "Spicy Tomato and Garlic Sauce"
}

PUT /proximity/4
{
    "title": "Tomato Saurce (spicy)"
}

PUT /proximity/4
{
    "title": "Spicy and very delicious Tomato Saurce"
}


// slop is used to identity the distance between the words to adjust the proximity in the search
GET /proximity/_search
{
    "query": {
        "match_phrase": {
            "title": "spicy sauce",
            "slop": 2
        }
    }
}

```

### Relevance query with proximity searches

The closer the proximity the higher the relevance score.

```c#
// get better results with relevance score for the search query by the proximity
GET /proximity/_search
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

### Fuzzy match query (handling typos)

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

//fuzzy query

GET /product/_search
{
    "query": {
        "fuzzy": {
            "name": {
                "value": "LOBSTER",
                "fuzziness": "auto"
            }
        }
    }
}
// fuzzy query is a term level query, no result found as results does not contain uppercase query. i.e query is not analyzed.

```

### Adding synonym

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
          "description": {
              "type": "text",
              "analyzer": "my_analyzer"
          }
      }
    }
}


POST /synonyms/_analyze
{
    "analyzer": "my_analyzer",
    "text": "awesome"
}

POST /synonyms/_analyze
{
    "analyzer": "my_analyzer",
    "text": "Elasticsearch"
}

POST /synonyms/_analyze
{
    "analyzer": "my_analyzer",
    "text": "weird"
}

POST /synonyms/_analyze
{
    "analyzer": "my_analyzer",
    "text": "Elasticsearch is awesome, but can also seem weird sometimes."
}
```

### Adding synonyms from file

can use `synonym_path: analysis/synonyms.txt` instead of listing the synonyms in the `synonyms` object. The path can be absolte or relative which should exist in the config folder. This need be done on all affected nodes. When new synonyms are added, existing docs will not match this mapping, Update by query API can be used to reindex and all docs will match the analyzer rules.

### Highlighing matches in fields

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


// Stemming is also supported by highlights
```
