# Elastic Search Complete guide - Controlling query results

## Result format

### YAML result

```c#
GET /recipe/_search?format=yaml
{ "query": { "match": { "title": "pasta" } } }

// in terminal
GET /recipe/_search?pretty
{ "query": { "match": { "title": "pasta" } } }
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

### Pagination: Results size (max num of hits) & offsets

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



```

### Sorting results

```c#
GET /receipe/_search
{
    "_source": "created"
    "query": {
        "match_all": []

    },
    "sort": [ { "create": "desc" } ]
}

GET /receipe/_search
{
    "_source": ["preparation_time_minutes", "created"],
    "query": { "match_all": [] },
    "sort": [
        { "preparation_time_minutes": "asc" },
        { "create": "desc" }
    ]
}

GET /receipe/_search
{
    "_source": ["ratings"],
    "query": { "match_all": [] },
    "sort": [
        {
            "ratings": {
                "order": "desc",
                "mode": "avg" //ratings is a list of numbers
            }
        }
    ]
}
```

