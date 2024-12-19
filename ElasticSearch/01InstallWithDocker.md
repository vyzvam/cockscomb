# Run ELK in Docker Desktop

## Pre-requisites

Docker desktop is installed

## Get the ES and Kibana images

```c#
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.16.1

docker pull docker.elastic.co/kibana/kibana:8.16.1
```

## Run ElasticSearch & Kibana

Prepare 2 terminal windows/tabs, one for ES the other for Kibana

```c#
// Create a network for the related containers
docker network create elastic

// run the es container
//alternate: run with limit memory usage
// docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:18.6.1
docker run --name es01 --net elastic -p 9200:9200 -it docker.elastic.co/elasticsearch/elasticsearch:8.16.1

// run the kibana container
docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.16.1
```

## Saving and using cedentials

1st time run of ES will have credentials in the log.
Copy ***password & enrollment tokens***.

Open the link from the kibana terminal for the first-time kibana setup into browser and paste the **Kibana enrollment token**.
get the verification code from kibana terminal and provide it in the browser.

### Copy the http ca certificate

`docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .`

For ease of use, copy the password into a variable

`export ELASTIC_PASSWORD=<thenewpassword>`

## Test your Curl

`curl --cacert http_ca.crt -u "elastic:$ELASTIC_PASSWORD" -X GET <https://localhost:9200>`

## Adding test data

Download data file: <https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json>

Run the _bulk API

```c#
curl --cacert http_ca.crt -u "elastic:$ELASTIC_PASSWORD" -H "Content-Type: application/x-ndjson" -XPOST https://localhost:9200/shakespeare/_bulk --data-binary "@shakespeare_6.0.json"
```

## Manage Credentials

If you wish not to use the default credentials, you can regenerate the ES password and enrollment token.

### Change password

```c#
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -i

// or run the command from within container
docker exec -i es01 //bin//sh

elasticsearch/bin/elasticsearch-reset-password -u elastic -i

exit //out of container, into bash
```



### Generate enrollment token

For new enrollment token, run the command

`docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana`

## Including additional nodes

```c#
docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s node

docker run -e ENROLLMENT_TOKEN="<token>" --name es02 --net elastic -it docker.elastic.co/elasticsearch/elasticsearch:8.16.1

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200/_cat/nodes
```