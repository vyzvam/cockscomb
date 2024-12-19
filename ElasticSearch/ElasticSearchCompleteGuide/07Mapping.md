# Elastic Search Complete guide - Mapping

## Mapping

* Defines the structure of the document (fields and their data types)
* Similar to a data schema in a relational database
* Explicit mapping (define field mapping ourselves)
* Dynamic mapping (ES generates field mappings for us)

e.g, object (json object), text, keyword

### Explicit Mapping

```c#
PUT /reviews
{
    "mapping": {
        "properties": {
            "rating": { "type": "float" },
            "content": { "type": "text" },
            "product_id": { "type": "integer" },
            "author": {
                "properties": {
                    "first_name": { "type": "text" },
                    "last_name": { "type": "text" },
                    "email": { "type": "keyword" }
                }
            }
        }
    }
}

PUT /reviews/_doc/1
{
    "rating": 5.0,
    "content": "Outstanding course! Bo really thaught me a lot about Elasticsearch!",
    "product_id": 123,
    "author": {
        "first_name": "John",
        "last_name": "Doe",
        "email": []
    }
}

GET /review/_mapping
GET /review/_mapping/field/content
GET /review/_mapping/field/author.email

// with dot notation
PUT /reviews_dotnotation
{
    "mapping": {
        "properties": {
            "rating": { "type": "float" },
            "content": { "type": "text" },
            "product_id": { "type": "integer" },
            "author.first_name": { "type": "text" },
            "author.last_name": { "type": "text" },
            "author.email": { "type": "keyword" }
        }
    }
}

// mapping for existing indices
PUT /review/_mapping
{ "properties": { "created_at": "date" } }
```

### Dates

Specified one of 3 ways:-

* Specially formatted string
* Miliseconds since epoch (long)
* Seconds since epoch (int)
* epoch refers to the 1st of January 1970
* Custom format

Default behaviour of date field:-

* Formats are in a date without time, date with time or miliseconds since epoch
* UTC timezone assumed if none is specified
* Dates must be formatted according to the ISO 8601 specification
* Dates are stored internally in milliseconds since epoch, any supplied valid value at index time is converted into a long value internally.
* Dates are converted to UTC timezone. Applicable for search queries as well.
* Don't provide UNIX timestamps for default date fields.

#### examples

```c#
PUT /reviews/_doc/2
{
    "rating": 4.5,
    "content": "Not bad, Not bad at all",
    "product_id": 123,
    "createrd_at": "2015-03-27",
    "author": {
        "first_name": "Average",
        "last_name": "Joe",
        "email": "avgjoe@example.com"
    }
}

PUT /reviews/_doc/3
{
    "rating": 3.5,
    "content": "Could be better"
    "product_id": 123,
    "createrd_at": "2015-04-15T13:07:41Z",
    "author": {
        "first_name": "Spencer",
        "last_name": "Pearson",
        "email": "spearson@example.com"
    }
}

PUT /reviews/_doc/4
{
    "rating": 5.0,
    "content": "Incredible!"
    "product_id": 123,
    "createrd_at": "2015-01-28T09:21:51+01:00",
    "author": {
        "first_name": "Adam",
        "last_name": "Jones",
        "email": "adam.jones@example.com"
    }
}

#2015-07-04T12:01:24Z
PUT /reviews/_doc/4
{
    "rating": 4.5,
    "content": "Very useful"
    "product_id": 123,
    "createrd_at": 1436011284000,
    "author": {
        "first_name": "Taylor",
        "last_name": "West",
        "email": "twest@example.com"
    }
}
```

### Missing fields

* All fields in ES are optional
* Fields can be left out when indexing
* Adding a field mapping does not make a field required

### Mapping parameters

* Format parameter can be used to specify date format.
* Properties parameter is used to specify nested fields for objects and nested fields
* Coerce parameter can be used to disable corcion or specify format. it can be also set at the index level.

## doc_values

It is another data structure used by Apache Lucene, optimized for a different data access pattern (document -> terms).
Used for sorting, aggregation and scripting. It is an additional data structure and not a replacement.
ES automatically queries the appropriate data structure depending on the query.
Can set the doc_values parameter to false to save disk space.
Can disable when not using sorting, aggregation or scripting.

### norms

Normalization factors used for relevance scoring.
Often we don't want to filter results, but also rank them.
norms parameter can be disable as it takes a lot of disk space

### index

It disables index for a field. i.e will not be used for searching.
Often used for time series data. take note that it can still be used for aggregation.

### null_value

Cannot be indexed or searched.
It can be use to replace NULL value with another value.
Only works for explicit NULL values.
The replcament value must be of the field's data type.

### copy_to

Used to copy multiple field values to a "group field".
Simply specify the target of the field as the value, e.g first_name and last_name to full_name
Values are copied not terms/tokens, The analyzer of the target field is used for the values.
The target field will not be part of the `_source` object.

#### Example

```c#
PUT /sales {
    "mapping": {
        "properties": {
            "first_name": {
                "type": "text",
                "copy_to": "full_name"
            },
             "last_name": {
                "type": "text",
                "copy_to": "full_name"
            },
            "full_name": { "type": "text", }
       }
    }
}
```

## Updating existing mapping

### Limitation

Generally, ES field mapping cannot be changed. We can only add new field mapping.
A few parameters can be updated for existing mapping.

### Field aliases

```c#
PUT /reviews/_mapping
{
    "properties": {
        "comments": { "type": "alias", "path": "content" }
    }
}
```

### Multi-field mapping

```c#
PUT /multi_field_test
{
    "mappings": {
        "properties": {
            "description": { "type": "text" },
            "ingredients": {
                "type": "text",
                "fields": { "keyword": { "type": "keyword" } }
            }
        }
    }
}

POST /multi_field_test/_doc
{
    "description" : "To make this spagghetti carbonara, you first need to...",
    "ingredients" : ["Spagghetti", "Bacon", "Eggs"]
}

// using a term level query
GET /multi_field_test_search
{
    "query": {
        "term": { "ingredients.keyword": "Spaggethi" }
    }
}
```

## Re-indexing documents

```c#

POST /_reindex
{
    "source": { "index": "reviews" },
    "dest": { "index": "reviews_new" }

}

POST /_reindex
{
    "source": { "index": "reviews" },
    "dest": { "index": "reviews_new" },
    "script": {
        "source": """
            if (ctx._source.product_id != null) {
                ctx._source.product_id = ctx._source.product_id.toString();
            }
        """
    }
}

POST /reindex
{
    "source": {
        "index": "reviews",
        "query": {
            "range": { "rating": { "gte": 4.0 } }
        }
    },
    "dest": { "index": "reviews_new" }
}

//  with source filtering
POST /reindex
{
    "source": {
        "index": "reviews",
        "_source": ["content", "created_at", "rating"]
    },
    "dest": { "index": "reviews_new" }
}

```

## Index template

When there is a need to dynamically create an index and index documents, by default it will use the default settings. When there is a template
that matches the index pattern exists, then the the settings and mappings in the template will be used.

* Index templates automatically apply settings and mapping to new indices (it works by matching teh index name against an index pattern)
* Only a single index template can be applied to a new index
* Useful for data sets that store data in multiple incides such as time series data
* Enables use of simply index documents into indices that don't already exist
* Indices can still be created manually( API request and index template are merged, the request takes precedence)
* Use priorities to allow overlapping index patterns (index template with highest priority is used)

```c#
PUT /_index_template/access-logs
{
    "index_patterns": ["access-logs-*"],
    "template": {
        "settings": {
            "number_of_shards": 2,
            "index.mapping.coerce"= false,

        },
        "mapping": {
            "properties": {
                "@timestamp": { "type": "date" },

                "url.original": { "type": "wildcard" },
                "url.path": { "type": "wildcard" },
                "url.scheme": { "type": "keyword" },
                "url.domain": { "type": "keyword" },

                "client.geo.continent_name": { "type": "keyword" },
                "client.geo.country_name": { "type": "keyword" },
                "client.geo.region_name": { "type": "keyword" },
                "client.geo.city_name": { "type": "keyword" },

                "user.agent.original": { "type": "keyword" },
                "user.agent.name": { "type": "keyword" },
                "user.agent.version": { "type": "keyword" },
                "user.agent.device.name": { "type": "keyword" },
                "user.agent.os.name": { "type": "keyword" },
                "user.agent.os.version": { "type": "keyword" },
            }
        }
    }
}

POST /access-logs-2023-01/_doc
{
    "@timestamp": "2023-01-01T00:00:00Z",
    "url.original": "https://www.example.com/products",
    "url.path": "/products",
    "url.scheme": "https",
    "url.domain": "example.com",
    "client.geo.continent_name": "Europe",
    "client.geo.country_name": "Denmark",
    "client.geo.region_name": "Capital City Region",
    "client.geo.city_name": "Copenhagen",
    "user.agent.original": "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari 604.1",
    "user.agent.name": "Safari",
    "user.agent.version": "12.0",
    "user.agent.device.name": "iPhone",
    "user.agent.os.name": "iOS",
    "user.agent.os.version": "12.1.0"
}

GET /_index_template/access-logs

// Update template are the same as creation

// deleting works the same way as others by specifying the DELETE verb.
DELETE /_index_template/access-logs

```

### Avoid these index patterns as they are used by ES

* logs-*-*
* metrics-*-*
* synthetics-*-*
* profiling-*-*

### Priorities

* Index templates cannot overlap by default, adding second index template will fail.
* Specify a priority option to both index templates to handle overlapping patterns
* Only a single index template can be applied to a new index

## Dynamic Mapping

ES automatically creates a mapping when a doc is indexed for the first time.
explicit and dynamic mapping can be combined, when a field is not specifed in mapping, ES will perform the dynamic mapping.

### Configuring

```c#
// disable dynamic mapping
PUT /people
{
    "mapping": {
        "dynamic": false,
        "properties": {
            "first_name": { "type": "text" }
        }
    }
}

// numeric detection
PUT /computers
{
    "mapping" { "numeric_detection": true }
}

// date detection
PUT /computers
{
    "mapping" { "date_detection": false }
}
```

Setting dynamic to false:-

* New fields are ignored, They are not index but still part of `_source`
* No inverted index is created for the field not specified in the mapping. Querying by this field will yield no results.
* Fields cannot be indexed without mapping

To force explicit mapping for all fields use the `strict` value for the `dynamic` key.
the `dynamic` setting can also be set at the each field level.

### Dynamic Templates

```c#

// by default ES will map whole numbers as long, we can configure this to set whole numbers to integers, as below.
PUT /dynamic_template_test
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

POST /dynamic_template_test/_doc
{ "in_stock": 123 }

GET /dynamic_template_test/_mapping

// another example for string
PUT /test_index
{
    "mapping": {
        "dynamic_templates": [
            {
                "strings": {
                    "match_mapping_type": "string",
                    "mapping": {
                        "type": "text"
                        "fields": {
                            "keyword": {
                                "type": "keyword",
                                "ignore_above": 512
                            }
                        }
                    }
                }
            }
        ]
    }
}
```

### match and unmatch

Use match and unmatch to detect field name pattern and apply the mapping.

### path_match and path_unmatch

Evaluate the full field path. for eg `"path_match": "employer.name.*"`.

### dynamic_type

can be used to allow dynamic mapping

```c#
// this mapping is set to not index any fields
PUT /test_index
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

### Index template vs dynamic templates

* Index templates apply mappings and index setting to matching indices. It happens when indices are created and their names match the pattern
* dynamic templates are evaluated when new fields are encountered & dynamic mapping is enabled. Added if the template condition is met
* Index mapping define fixed mapping. dynamic templates are dynamic.

## Recommendation

### Use explicit mapping

* Dynamic mapping is convenient, but often not a good idea for production
* Save disk space with optimized mapping when storing many documents
* Set `dynamic` to `strict`, not `false`, Avoid suprises and unexpected results

Mapping of text fields

* Dont' always map string as both `text` and `keyword`. Typically only one is needed, each mapping requires disk space.
* add `text` mapping if full-text searches is needed.
* add `keyword` mapping if sorting, aggregation or filtering is required.

### Disable coercion

Coercion forgives you for not doing the right thing. Try to do the right thing instead.
Always use the correct data types whenever possible.

### Use appropriate numeric data types

* For Whole numbers `integer` data type might be enough. (long can store larger numbers, but also uses more disk space)
* For decimals, `float` data type might be precise enough. `double` has higher precision but uses 2x disk space.

### Optimizing Mapping parameters

* `doc_values` to false if sorting, filtering and aggregation is not required
* `norms` to false if relevance scoring is not required
* `index` to false if filtering is not required (can still do aggregation)

Consider the amount of document when making decision, low number of docs (below 1M) may not be worth it set these rules and overcomplicate things.

