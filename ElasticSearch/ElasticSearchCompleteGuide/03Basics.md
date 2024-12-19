# Elastic Search Complete guide - Basics

## Architecture

### Cluster

An Elasticsearch cluster is a **group of one or more node instances that are connected together**. The power of an Elasticsearch cluster lies in the **distribution of tasks, searching, and indexing, across all the nodes in the cluster**.

### Node

A node is a single server that is a part of a cluster. A node stores data and participates in the cluster’s indexing and search capabilities.

An Elasticsearch node can be configured in different ways:

* **Master Node** — Controls the Elasticsearch cluster and is responsible for all cluster-wide operations like creating/deleting an index and adding/removing nodes.
* **Data Node** — Stores data and executes data-related operations such as search and aggregation.
* **Client Node** — Forwards cluster requests to the master node and data-related requests to data nodes.

### Indices & documents

An index groups similar documents (which is stored in JSON format)

## Checking our cluster

Go to kibana dev tool
run the command `GET /_cluster/health`

run the command
`GET /_cat/nodes?vi`
`GET /_cat/nodes?v&expand_wildcards=all`

## using CURL to query elastic search

```c#
// this would fail as ES expect https), empty reply from server
curl -X GET http://localhost:9200

// this will show a ssl certificate problem
curl -X GET https://localhost:9200

// this will show a security exception
curl --insecure -X GET https://localhost:9200

// ssl issue resolved, but expect to be authenticated
curl --cacert config/certs/http_ca.crt -X GET https://localhost:9200

//Will prompt for password
curl --cacert config/certs/http_ca.crt -u elastic -X GET https://localhost:9200

// (no prompt, provide results)
curl --cacert config/certs/http_ca.crt -u elastic:szE*0gXro3iCOv_*VteB -X GET https://localhost:9200
```

## query for data

```c#
curl --cacert config/certs/http_ca.crt -u elastic:6MY8sjUPh8PaxOuvVi3X -X GET -H "Content-Type:application/json"<https://localhost:9200/products/_search> -d '{ "query": { "match_all": {} } }'

curl --cacert config/certs/http_ca.crt -u elastic:szE*0gXro3iCOv_*VteB -X GET -H "Content-Type:application/json"<https://localhost:9200/products/_search> -d '{ "query": { "match_all": {} } }'

```