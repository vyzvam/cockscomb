# Elastic Search Complete guide - Aggregations

## Example using order index

```c#
// view mapping of the index first
GET /order/_mapping
```

## Metrics Aggregations

### Single-value * Multi-value numeric metric aggregation

```c#
// Get total, average, min, and max total amount
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "total_sales": {
            "sum": { "field": "taxful_total_price" }
        },
        "avg_sale": {
            "avg": { "field": "taxful_total_price" }
        },
        "min_sale": {
            "min": { "field": "taxful_total_price" }
        },
        "max_sale": {
            "max": { "field": "taxful_total_price" }
        }
    }
}

// Get number of docs with taxful_total_price
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "values_count": {
            "value_count": { "field": "taxful_total_price" } }
    }
}

// Get total unique customers by their full name
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "total_customer": {
            "cardinality": { "field": "customer_full_name.keyword" }
        }
    }
}


// Get stats of taxful_total_price (count, sum, avg, min & max)

GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "amount_stats": {
            "stats": {
                "field": "taxful_total_price"
            }
        }
    }
}

```

## Bucket Aggregations

```c#

// create a bucket for each country
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "status_terms": {
            "terms": {
                "field": "geoip.country_iso_code",
                "missing": "N/A",
                "min_doc_count": 0,
                "order": { "_key": "asc" }
            }
        }
    }
}
```

* The response has sum_other_doc_count key number of term value this is not part of the result.
* The "missing" key creates a bucket that has missing doc count in the results
* the min_doc_count specifies the min count that should be included in the results.

### Terms query gives an approximate result

This is due the distributed nature of ES.
The coordinating node get results from each shard and calculates the result. The coordinating node matches the results based on the order it receive it does not know about the key used for sorting. thus might calculated against the wrong key.
`doc_count_error_upper_bound` reduces the error rate.

### Nested Aggregations (sub aggregations)

```c#

// get stats for each country
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "query": {
        "range": { "taxful_total_price": { "gte": 100 } }
    },
    "aggs": {
        "status_terms": {
            "terms": {
                "field": "geoip.country_iso_code"
            },
            "aggs": {
                "status_stats": {
                    "stats": { "field": "taxful_total_price" }
                }
            }
        }
    }
}
```

### Filtering documents

```c#
// Get stas on purchase below 50 EURO
GET /kibana_sample_data_ecommerce/_search
{
    "size": 0,
    "aggs": {
        "low_value": {
            "filter": {
                "range": {
                    "taxful_total_price": {
                        "lt": 50
                    }
                }
            },
            "aggs": {
                "avg_amount": {
                    "avg": { "field": "taxful_total_price" }
                }
            }
        }
    }
}
```

### Defining bucket rules with filters

```c#
// Get total sales done by Elitelligence & Pyramidustries
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
      "myfilter": {
          "filters": {
              "filters": {
                  "Elitelligence": { "match":{ "manufacturer": "Elitelligence" } },
                  "Pyramidustries": { "match": { "manufacturer": "Pyramidustries" } }
              }
          },
          "aggs": {
              "total_sales": { "sum": { "field": "taxful_total_price" } }
          }
      }
  }
}
```

### Range aggregations

There are `range` and `date_range`.

```c#
GET /kibana_sample_data_ecommerce/_search
{
  "size": 0,
  "aggs": {
      "sales_distribution": {
          "range": {
              "field": "taxful_total_price",
              "ranges": [
                  { "to": 50 },
                  { "from": 50, "to": 100 },
                  { "from": 100 }
              ]
          }
      }
  }
}

GET /order/_search
{
    "size": 0,
    "aggs": {
        "purchased_ranges": {
            "date_range": {
                "field": "purchased_at",
                "format": "yyyy-MM-dd",
                "key": true //each anonymous object key becomes object
                "ranges": [
                    {
                        "from": "2016-01-01",
                        "to": "2016-01-01||+6M",
                        "key": "first_half"
                    },
                    {
                        "from": "2016-01-01||+6M",
                        "to": "2016-01-01||+6y",
                        "key": "second_half"
                    }
                ]
            },
            "aggs": {
                "bucket_stats": {
                    "stats": {
                        "field": "total_amount"
                    }
                }
            }
        }
    }
}
```

### Histogram

```c#
GET /order/_search
{
    "query": {
        "size": 0,
        "query": {
            "range": { "total_amount" { "gte": 100 } }
        }
        "aggs": {
            "amount_distribution": {
                "histogram": {
                    "field": "total_amount",
                    "interval": 25,
                    "min_doc_count": 1,
                    "extended_bounds": {
                        "min": 0,
                        "max": 500
                    }
                }
            }
        }
    }
}

GET /order/_search
{
    "size": 0,
    "aggs": {
        "orders_over_time": {
            "date_histogram": {
                "field": "purchased_at",
                "interval": "month"
            }
        }
    }
}
```

### Global aggregation

```c#
GET /order/_search
{
    "size": 0,
    "query": {
        "range": {
            "total_amount": {
                "gte": 100
            }
        }
    },
    "aggs": {
        "stats_expensive": {
            "stats": { "field": "total_amount" }
        }
        "all_orders": {
            "global": {
                "aggs": {
                    "stats_amount": {
                        "stats": {
                            "field": "total_amount"
                        }

                    }
                }
            }
        }
    }
}
```

## Missing / null fields

```c#
GET /order/_search
{
    "size": 0,
    "aggs": {
        "orders_without_status": {
            "missing": { "field": "status" },
            "aggs": {
                "missing_sum": { "sum": { "field": "total_sum" } }
            }
        }
    }
}
```

## Nested aggregation

```c#
GET /department/_search
{
    "size": 0,
    "aggs": {
        "employees": {
            "nested": { "path": "employees" }
        },
        "aggs": {
            "minimum_age": { "min": { "field": "employees.age" } }
        }

    }
}
```