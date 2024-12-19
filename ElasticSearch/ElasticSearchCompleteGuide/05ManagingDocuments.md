# Elastic Search Complete guide - Managing Documents

## Indice Creation / Deletion & indexing documents

Remove the previously created pages index

```c#
DELETE /pages
```

Create new index 'product' and specify shard count and replica count

```c#
PUT /products
{
    "settings": {
        "number_of_shards": 2
        "number_of_replicas": 2
    }
}
```

Index & retrieve documents

```c#
POST /products/_doc
{
    "name": "Coffee Maker"
    "price": 64
    "in_stock": 10
}

PUT /products/_doc/100
{
  "name": "Toaster",
  "price": 42,
  "in_stock": 5
}

GET /products/_doc/100
```

Updating existing document

```c#
POST /products/_update/100
{
    "doc": {
        "in_stock": 3
    }
}

POST /products/_update/100
{
    "doc": {
        "tags": ["electronics"]
    }
}
```

Scripted updates

```c#
POST /products/_update/100
{
    "script": {
        "source": "ctx._source.in_stock--"
    }
}

POST /products/_update/100
{
    "script": {
        "source": "ctx._source.in_stock = 10"
    }
}

POST /products/_update/100
{
    "script": {
        "source": "ctx._source.in_stock -= params.quantity"
        "params": {
            "quantity": 4
        }
    }
}
```

Updated indexes can result in noop status if the values are the same. In the case of scripted updated, it will always result in updated.
This can be manipulated by including conditions in the script itself.

```c#
// noop example
POST /products/_update/100
{
    "script": {
        "source": """
            if (ctx._source.in_stock == 0) {
                ctx.op = 'noop';
            }

            ctx.source.in_stock--;
        """
    }
}

// this will still result in updated
POST /products/_update/100
{
    "script": {
        "source": """
            if (ctx._source.in_stock > 0) {
                ctx.source.in_stock--;
            }

        """
    }
}

// this will result in deleted
POST /products/_update/100
{
    "script": {
        "source": """
            if (ctx._source.in_stock <= 0) {
                ctx.op = 'deleted';
            }

            ctx.source.in_stock--;
        """
    }
}
```

Upserting, replacing & deleting document

```c#

POST /products/_update/101
{
    "script": {
        "source": "ctx.source.in_stock++"
    },
    "upsert": {
        "name": "Blender",
        "price": 399,
        "in_stock": 5
    }

}

// replace document
PUT /products/_doc/100
{
    "name": "Toater",
    "price": 79,
    "in_stock": 4
}
// the whole document is now replaced

DELETE /products/_doc/100
```

## Routing

formula shard_num = `hash(_routing) % num_primary_shards`

The default routing method helps distributes indexes evenly accross shards.
When using a custom routing method a "_route" key is created for the document.

Routing :-

* Is a Process of resolving a shard for a document
* Use when indexing, retrieving & updating documents
* Can be customized
* Default strategy distributes documents evenly
* An index' shards cannot be changed since the routing formula will yield different results.

## How ES reads data

When a given node (coordinating node) received the read request, it will formulate where the document is stored.
It resolves to a primary shard. ES uses a technique calls Adaptive Replica Selection (ARS) for this purpose.

* A read request is received by a coordinating node
* Routing is used to resolve the documents' replication group
* ARS is used to send the request to the best available shard. ARS, which is an intelligent load balancer reduces the query response time.
* The coordinating node collects the response and sends it to the client.

## How ES writes data

* Write operations are sent to primary shards
* The primary shards forwards the operations to it's replica shards
* Primary terms and sequence numbers are used to recover from failures
* Global and local checkpoints help speed up recovery process

## Versionining

### Types

Internal (default) and external (explicit)

### Optimistic concurrency control

Example: when two customers purchases a product at the same time, the stock count will show the same value and be deducted from the same value.
The old way of managing this is by using the _version field. The new approach is to use the primary term and sequence number.

```c#
GET /product/_doc/100

POST /product/_update/100?if_primary_term=x&if_sequence_number=y
{
    "doc": {
        "in_stock": 200
    }
}
```

## Update & delete by query

```c#
POST /products/_update_by_query
{
  "script": {
    "source": "ctx._source.in_stock--"
  },
  "query": {
      "match_all": {}
  }
}

// proceeds to update even when there are conflicts
POST /products/_update_by_query
{
  "conflicts": "proceed"
  "script": {
    "source": "ctx._source.in_stock--"
  },
  "query": {
      "match_all": {}
  }
}

// Delete by query
POST /products/_delete_by_query
{
  "query": {
      "match_all": {}
  }
}
```

## Batch processing

```c#
POST /_bulk
{ "index": { "_index": "products", "_id": 200 } }
{ "name": "Espresso Machine", "price": 199, "in_stock": 5 }
{ "create": { "_index": "products", "_id": 201 }}
{ "name": "Milk Frother", "price": 149, "in_stock": 14 }


POST /_bulk
{ "update": { "_index": "products", "_id": 201 } }
{ "doc": {"price": 129 } }
{ "delete": { "_index": "products", "_id": 200 }}
// or
POST /products/_bulk
{ "update": { "_id": 201 } }
{ "doc": {"price": 129 } }
{ "delete": { "_id": 200 }}
```

When is bulk api useful:-

* When lots of write operation at the same time is required
* It is more efficient than sending individual write requests. Alot of network roundtrips are avoided.

## importing with cURL

```c#
curl -k -u elastic -H "Content-Type:application/x-ndjson" -XPOST https://localhost:9200/products/_bulk --data-binary "@products-bulk.json"

curl --cacert /path/to/http_ca.crt -u elastic -H "Content-Type:application/x-ndjson" -XPOST https://localhost:9200/products/_bulk --data-binary "@products-bulk.json"
```
