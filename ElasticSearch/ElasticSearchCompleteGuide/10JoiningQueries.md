# Elastic Search Complete guide - Joining Queries


## Creating relationships

### Create an index for department

```c#
PUT /department
{
  "mappings": {
    "properties": {
      "name": {
        "type": "text",
        "fields": { "keyword": { "type": "keyword" } }
      },
      "employees": { "type": "nested" }
    }
  }
}
```

### Create relationship

```c#
PUT /department
{
    "mappings": {
        "_doc": {
            "properties": {
                "join_field": {
                    "type": "join",
                    "relations": {
                        "department": "employee"
                    }
                }
            }
        }
    }
}
```

### index department and employee data

```c#
PUT /department
{
    "name": "Development",
    "join_field": "department"
}

PUT /department
{
    "name": "Marketing",
    "join_field": "department"
}

PUT /department?routing=1
{
    "name": "Suba",
    "age":46,
    "gender": "m"
    "join_field": {
        "name": "employee",
        "parent": 1
    }
}
```

## Querying results

### Query by parent id

```c#
"query": { "parent_id": { "type": "employee", "id": 1 } }
```

### Query child document by parent

```c#
"query": {
    "has_parent": {
        "parent_type": "department",
        "query": { "term": { "name.keyword": "Development" } }
    }
}

// with relevance score
"query": {
    "has_parent": {
        "parent_type": "department",
        "score": true
        "query": { "term": { "name.keyword": "Development" } }
    }
}
```

### Query parent document by child

```c#
"query": {
    "has_child": {
        "type": "employee",
        "query": {
            "bool": {
                "must": [{ "range": { "age": { "gte": 50 } } }],
                "should": [ {"term": { "gender.keyword": "M" }} ]
            },
            "term": { "name.keyword": "Development" }
        }
    }
}

// with relevance score
"query": {
    "has_child": {
        "type": "employee",
        "score_mode": "sum", // available option min|max|avg|sum|none
        "min_children": 2,
        "max_children": 5,
        "query": {
            "bool": {
                "must": [{ "range": { "age": { "gte": 50 } } }],
                "should": [ {"term": { "gender.keyword": "M" }} ]
            },
            "term": { "name.keyword": "Development" }
        }
    }
}
```

## Multi level relation

Use case: Company -> Department -> Employee, Company -> Supplier

```c#
PUT /company
{
    "mappings": {
        "properties": {
            "join_field": {
                "type": "join",
                "relation": {
                    "company": ["department", "supplier"],
                    "department": "employee"
                }
            }
        }
    }
}

PUT /company/_doc/1
{
    "name": "my company",
    "join_field": "company"
}

PUT /company/_doc/2?routing=1
{
    "name": "my department",
    "join_field": { "name": "department", "parent": 1 }
}

PUT /company/_doc/3?routing=1
{
    "name": "my employee",
    "join_field": { "name": "employee", "parent": 2 }
}

PUT /company/_doc/4?routing=1
{
    "name": "my supplier",
    "join_field": {
        "name": "supplier",
        "parent": 1
    }
}

GET /company/_search
{
    "query": {
        "has_child": {
            "type": "department",
            "query": {
                "has_child": {
                    "type": "employee",
                    "query": { "term": { "name.keyword": "John Doe" } }
                }
            }
        }
    }
}

// with inner hits
"query": {
    "has_child": {
        "type": "employee",
        "inner_hits": {}
        "score_mode": "sum", // available option min|max|avg|sum|none
        "min_children": 2,
        "max_children": 5,
        "query": {
            "bool": {
                "must": [{ "range": { "age": { "gte": 50 } } }],
                "should": [ {"term": { "gender.keyword": "M" }} ]
            }
            "term": {
                "name.keyword": "Development"
            }
        }
    }
}
```

## Term lookup mechanism

```c#
GET /stories/_search
{
    "query":
    {
        "terms": {
            "user": {
                "index": "user",
                "type": "_doc"
                "id": "1",
                "path": "following"
            }
        }
    }
}
```

## limitatins & performance considerations

* Docs must be stored in the same index
* Parent and child must be indexed in the same shard
* Only one join field per index, it can have as many relations
* A document can only have one parent
* Using join fields are slow