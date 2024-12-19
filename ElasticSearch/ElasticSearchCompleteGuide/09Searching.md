# Elastic Search Complete guide - Searching

## Introduction

Search can be done in 2 ways:-
* URI search, search queries as query parameter `GET /products/_search?q-name:sauvignon AND tags:wine`.This is done by using Apache Lucene query string syntax.
* Query DSL, it's used in the request body as JSON object.

```c#
GET /products/_search
{ "query": { "match_all": {} } }
```

## Term level query

* Used to search structured data for exact values (filter)
* Term level queries are not analyzed, the search value is used as it is for inverted index lookup.
* Can be used with these data types: keywords, numbers, dates, etc
* Don't use term level queries on text data type

```c#
GET /products/_search
{ "query": { "term": { "brand.keyword": "Nike" } } }

GET /products/_search
{
    "query": {
        "term": {
            "tags.keyword": {
               "value": "Vegetable",
               "case_insensitive": true
            }
        }
    }
}

GET /products/_search
{
    "query": {
        "term": { "tags.keyword": ["Soup", "meay"] }
    }
}
```

### Retrieve by ID

```c#
GET /products/_search
{
    "query": {
        "ids": { "values": ["100", "200", "300"] }
    }
}
```

### Range searches

```c#
GET /products/_search
{
    "query": {
        "range": {
            "in_sock": { "gte": 1, "lte": 5 }
        }
    }
}

// dates without time
GET /products/_search
{
    "query": {
        "range": {
            "created": {
                "format": "yyyy/MM/dd" // optionally specify input format
                "timezone": "+01:00" // optionally specify input timezone
                "gte": "2020/01/01",
                "lte": "2020/01/31"
            }
        }
    }
}
```

### Prefix, wildcard & Regexp

```c#
// Prefix
GET /products/_search
{
    "query": {
        "prefix": { "name.keyword": { "value": "Past" } }
    }
}

// Wildcard "?" or "*"
GET /products/_search
{
    "query": {
        "wildcard": { "name.keyword": { "value": "Bee*" } }
    }
}

// Regex
GET /products/_search
{
    "query": {
        "regexp": { "name.keyword": { "value": "Bee(f|r)+" } }
    }
}
```

### NULL related

```c#
// get results where it is NOT null
GET /products/_search
{
    "query": {
        "exists": { "field": "tags.keyword" }
    }
}

// get results where it is null
GET /products/_search
{
    "query": {
        "bool": {
            "must_not": { "exists": "tags.keyword" }
        }
    }
}
```

Reason for no indexed value:-

* Empty value (NULL or []) is provided, the `null_value` parameter is an exception for NULL values
* No value provided for the field
* The index mapping parameter is set to false for the field
* The value's length is greater than the `ignore_above` parameter
* Malformed value with the `ignore_malformed` mapping parameter is set to true

## Full text queries

* The `bool` query is one of the most important query in ES
* if `bool` query only contains `should` clauses, at least one is required to match. Can be adjusted with the `minimum_should_match` parameter
* Occurence types
    * `must`: Must match, affects relevance scoring
    * `must_not`: Must not match
    * `should`: Boosts relevance scores for matching docs. Often used with the combination with `must` and/or `filter`
    * `filter`: Must match. Ignores relevance score and cacheable
* `match` queries are usually translated into `bool` queries internally.

### Match queries

```c#
// match query
GET /products/_search
{
    "query": {
        "match": { "name": "pasta" } }
}

// match OR
GET /products/_search
{
    "query": {
        "match": { "name": "pasta chicken" }
    }
}

// match AND
GET /products/_search
{
    "query": {
        "match": {
          "name": {
            "query": "pasta chicken", "operator": "AND" }
        }
    }
}
// relevance score is based on best match terms and their position
```

### Multi-match queries

```c#
// multi match
GET /products/_search
{
    "query": {
        "multi_match": {
            "query": "vegetables", "fields" : ["name", "tags"] }
    }
}

// by default only one term's relevance score from a doc is used for scoring
// this can be adjusted by using the tie_breaker parameter. this is called relevance boosting
{
    "query": {
        "multi_match": {
            "query": "vegetables", "fields" : ["name", "tags"], "tie_breaker": 0.3
         }
    }
}

// the score from the other matching fields will be multiplied with the tie_breaker and added to the relevance score.

// phrase searching
// every term must match in the exact order and without any other terms inbetween
{
    "query": {
        "match_phrase": { "description": "Complete guide to Elasticsearch" }
    }
}
```

### Leaf vs. compound queries

So far we covered term and full text search which are leaf queries.
Compound queries wrap other queries to produce results.

```c#
GET /products/_search
{
    "query": {
        "bool": {
            "must": [
                { "term": { "tags.keyword": "Alcohol" } }
            ],
            "must_not": [
                { "term": { "tags.keyword": "Wine" } }
            ],
            "should": [
                { "term": { "tags.keyword": "Beer" } },
                { "match": { "description": "Beer" } }
            ]
        }
    }
}
// should condition increases the score value of results containing the value
```

Important notes about `should` :-

* If a bool query only contains `should` clauses, at least one must match. Useful when something to match and reward matching documents. if nothing were required to match, we'll get irrelevant results
* if a query clause contains `must`, `must_not`, or `filter`, no `should` clause is required to match as they are used only for relevance scoring. `minimum_should_match` key can be used to configure this

### Filter

```c#
// Query clauses must match similar to `must` occurence type. It ignores relevance scores and improves performance
{
    "query": {
        "bool": {
            "filter": {
                "term": { "tags.keyword": "Alcohol", }
            }
        }
    }
}
```

### More on match query

```c#
GET /products/_search {
    "query": {
        "match": { "name": "PASTA CHICKEN" }
    }
}

// The query above is translated by ES to
GET / products/_search {
    "query": {
        "bool": {
            "should": {
                "term": { "name": "pasta" },
                "term": { "name": "chicken" }
            }
        }
    }
}

// Another example : sql query - `WHERE (tags IN ("Beer") OR name LIKE '%Beer%') AND in_stock <= 100`
GET / products/_search {
    "query": {
        "bool": {
            "filter": {
                "range": { "in_stock": { "lte": 100 } }
            },
            "should": {
                "term": { "tags.keyword": "Beer" },
                "match": { "name": "Beer" },
            },
            "minimum_should_match": 1
        }
    }
}


// Another example : sql query - `WHERE tags IN ("Beer") AND  (name LIKE '%Beer%' description LIKE '%Beer%") AND in_stock <= 100
GET / products/_search {
    "query": {
        "bool": {
            "filter": {
                "range": { "in_stock": { "lte": 100 } }
                "term": { "tags.keyword": "Beer" }
            }
            "must": {
                "multi_match": {
                    "query": "Beer",
                    "fields": ["name", "description"]
                }
            }
        }
    }
}
```

### Query exeecution context

* Answers these questions
    * Does this document match (yes/no)
    * How well this document match (`_score` metadata field)
    * Query results are sorted by `_score` descendingly

### Filter execution context

* answers the question of does this document match (yes/no) (no relevance score calculated)
* Used to filter data, typically structured (dates, numbers, keyword)
* Improves performance, No resources are spent for relevance scoring * results can be cached

### Changing execution context

* Possible to change context, only few queries support it.
* Typically done with the `filter` aggregation and `bool` query
* Queries that support this generally have a `filter` parameter

## Boosting query

* The `bool` query can increase relevance scores with `should`
* The `boosting` query can decrease the relevance score with `negative`
    * docs must match the `postive` query clause
    * docs that matches the `negative` query clause have their relevance score decreased
    * Use `match_all` for `postitive` if don't want to filter docs
    * Can be used with any queries (including compound queries such as `bool`)

The `bool` query enables us to increase relevance scores with `should`.
Boosting query can decrease the relevance scores for some documents.

```c#
// search for "Juice" where reduces the relevance score for "apple"
GET /products/_search
{
    "size": 20, //number of results, overwrites the default result of 10
    "query": {
        "boosting": {
            "positive": {
                "match": { "name": "juice" }
            },
            "negative": {
                "match": { "name": "apple" }
            },
            "negative_boost": 0.5
        }
    }
}

// search for any name where reduces the relevance score for "apple"
GET /products/_search
{
    "size": 20, //number of results, overwrites the default result of 10
    "query": {
        "boosting": {
            "positive": {
                "match_all": { }
            },
            "negative": {
                "match": { "name": "apple" }
            },
            "negative_boost": 0.5
        }
    }
}

// increase the relevance scores for recipes containing pasta
GET /products/_search
{
    "query": {
        "bool": {
            "must": { "match_all": { } },
            "should": { "term": { "ingredients.name.keyword": "pasta" } }
        }
    }
}
// decrease the relevance scores for recipes containing bacon
GET /products/_search
{
    "query": {
        "boosting": {
            "postive": { "match_all": { } },
            "negative": { "term": { "ingredients.name.keyword": "bacon" } },
            "negative_boost": 0.5
        }
    }
}

// Combine the both: "i like pasta but not bacon
GET /products_search
{
    "query": {
        "positive": {
            "term": { "ingredients.name.keyword": "pasta" }
        },
        "negative": {
            "term": { "ingredients.name.keyword": "bacon" }
        },
        "negative_boost": 0.5

    }
}

// Combine the both: "i like pasta but not with bacon
GET /products_search
{
    "query": {
        "positive": {
            "bool": {
                "must": [ { "match_all": {} } ],
                "should": [ { "term": { "ingredients.name.keyword": "pasta" } } ]
            }
        },
        "negative": { "term": { "ingredients.name.keyword": "bacon" } },
        "negative_boost": 0.5

    }
}
```

## disjunction max (dis_max)

* Is a compound query (a doc matches if at least one leaf query matches)
* The best matching query clause relevance score is used for document's _score
* `tie_breaker` can be used to reward documents that match multiple queries
* `multi_match` queries are often translated to `dis_max` queries internally

The `_score` of the search results are calculated based on the best matching query, i.e the highest relevant score, unless a `tie_breaker` is specified. `tie_breaker` is used when other matching queries relevance score is multiplied by the tie_breaker value (0.0 0 1.0) and added to the highest relevance score.

```c#
GET /products/_search
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "name": "vegetable" } },
                { "match": { "tags": "vegetable" } }
            ]
        }
    }
}
```

### How multi_match query works

`multi_match` queries are converted to dis_match queries by ES

```c#

// multi match query
GET /products/_search
{
    "query": {
        "multi_match": {
            "query": "vegetable",
            "fields": ["name", "tags"],
            "tie_breaker": 0.3
        }
    }
}

// to dis_max query
GET /products/_search
{
    "query": {
        "dis_max": {
            "queries": [
                { "match": { "name": "vegetable"}},
                { "match": { "tags": "vegetable"}},
                "tie_breaker": 0.3
            ]
        }
    }
}
```

## Querying nested object

```c#
GET /products/_search
{
    "query": {
        "bool": {
            "must": {
                "match": { "ingredients.name": "parmesan" }
            },
            "range": { "ingredients.amount": { "gte": 100 } }
        }
    }
}
```

The query above yields mixed results, take note that not all doc have the ingredients.amount key. the result can contains either results which is not accurate.

When reviewing field mapping `GET /recipes/_mapping`. The index is created with the dynamic field mapping. note that the ingredients field is an array of objects.

When indexing array of objects , the relationship between values are not maintained and queries can yield unpredictable results.
To solve this, use nested data type and nested query, create a new index to update the field mapping & reindex docs.

```c#
PUT /recipes {
    "mapping": {
        "properties": {
            "title": { "type": "text" },
            "description": { "type": "text" },
            "preparation_time_minutes": { "type": "integer" },
            "steps": { "type": "text" },
            "created": { "type": "date" },
            "ratings": { "type": "float" },
            "ratings": { "type": "float" },
            "servings": {
               "properties": {
                    "min": { "type": "integer" },
                    "max": { "type": "integer" }

               }
            },
            "ingredients": {
                "type": "nested,
                "properties": {
                    "name": {
                        "type": "text",
                        "fields": {
                            "keyword": { "type": "keyword" }
                        }
                    },
                    "amount": { "type": "integer" },
                    "unit": { "type": "keyword" }
                }
            }
        }
    }
}

GET /recipes/_search
{
    "query": {
        "nested": {
            "path": "ingredients",
            "query": {
                "bool": {
                    "must": { "match": { "ingredients.name": "parmesan" } },
                    "range": { "amount": { "ingredients.gte": 100 }
                    }
                }
            }
        }
    }
}
```

### Nested queries and relevance scoring

* Matching child document affect the parent doc relevance score
* ES calculates a relevance score for each matching child object, each nested object is a Lucene document
* Relevance scoring can be adjusted with the `score_mode` parameter, `avg` (default), `min`, `max` `sum`, `none`.

### Nested objects query summary

* To query objects independanty use the `nested` data type, else the relationship between objects are not maintained. each nested object is index as a lucene doc.
* Use nested query on fields with the nested data type.
* Use `score_mode` parameter to adjust the relevance scoring


### Nested inner hits

providing a `"inner_hits": {}` parameter, yields an additional result called "inner_hits".

* Nested inner hits tells us which nested object(s) matched a query
* Add the `inner_hits` parameter within the `nested` query, use `{}` as value for default behaviour. Use `offset` key to find each object's position within `_source`. customize results by using the `name` and `size` parameters

### Nested fields Limitations

* Indexing and querying nested fields is more expensive than other data types
* An Apache Lucene document is created for each nested object. Increased storage and query cost
* ES provides safeguards to reduce the risk of performance bottlenecks.
    * Use specialized data type and query (nested)
    * Max 50 nested fields per index, can be increase with the setting `index_mapping.nested_fields.limit` (not recommeded)
    * 10,000 nested objects per document (accross all nested fields), protects against OOM exception