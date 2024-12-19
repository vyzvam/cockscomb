# Ingest Pipelines

## General

Perform common ***transformations on data before indexing***.
For example, to ***remove fields, extract values from text***, and enrich data.

A pipeline consists of a series of configurable tasks called processors. Each processor runs sequentially, making specific changes to incoming documents. After the processors have run, Elasticsearch adds the transformed documents to data stream or index.

## Pipeline Example

```c#
PUT _ingest/pipeline/my-pipeline
{
  "description": "My pipeline",
  "version": 1
  "processors": [
    {
      "set": {
        "description": "My optional processor description",
        "field": "my-long-field",
        "value": 10
      }
    },
    {
      "set": {
        "description": "Set 'my-boolean-field' to true",
        "field": "my-boolean-field",
        "value": true
      }
    },
    {
      "lowercase": { "field": "my-keyword-field" }
    }
  ]
}
```

## Test created pipeline

```c#
POST _ingest/pipeline/my-pipeline/_simulate
{
  "docs": [
    { "_source": { "my-keyword-field": "FOO" } },
    { "_source": { "my-keyword-field": "BAR" } }
  ]
}
```

## Test pipline before creation

```c#
POST _ingest/pipeline/_simulate
{
  "pipeline": {
    "processors": [
      {
        "lowercase": { "field": "my-keyword-field" }
      }
    ]
  },
  "docs": [
    { "_source": { "my-keyword-field": "FOO" } },
    { "_source": { "my-keyword-field": "BAR" } }
  ]
}
```

## Add pipeline to an indexing request

```c#
POST my-data-stream/_doc?pipeline=my-pipeline
{
  "@timestamp": "2099-03-07T11:04:05.000Z",
  "my-keyword-field": "foo"
}

PUT my-data-stream/_bulk?pipeline=my-pipeline
{ "create":{ } }
{ "@timestamp": "2099-03-07T11:04:06.000Z", "my-keyword-field": "foo" }
{ "create":{ } }
{ "@timestamp": "2099-03-07T11:04:07.000Z", "my-keyword-field": "bar" }
```

## Use with Update by query and reindex

```c#
POST my-data-stream/_update_by_query?pipeline=my-pipeline

POST _reindex
{
  "source": {
    "index": "my-data-stream"
  },
  "dest": {
    "index": "my-new-data-stream",
    "op_type": "create",
    "pipeline": "my-pipeline"
  }
}
```

## Set a default or final pipeline

Use the `index.default_pipeline` index setting to set a default pipeline. Applied to indexing requests if no pipeline parameter is specified.

Use the `index.final_pipeline` index setting to set a final pipeline. Applied after the request or default pipeline, even if neither is specified.

## Handling failures

```c#
PUT _ingest/pipeline/my-pipeline
{
  "processors": [
    {
      "rename": {
        "description": "Rename 'provider' to 'cloud.provider'",
        "field": "provider",
        "target_field": "cloud.provider",
        "ignore_failure": true
      }
    }
  ]
}

PUT _ingest/pipeline/my-pipeline
{
  "processors": [
    {
      "rename": {
        "description": "Rename 'provider' to 'cloud.provider'",
        "field": "provider",
        "target_field": "cloud.provider",
        "on_failure": [
          {
            "set": {
              "description": "Set 'error.message'",
              "field": "error.message",
              "value": "Field 'provider' does not exist. Cannot rename to 'cloud.provider'",
              "override": false
            }
          }
        ]
      }
    }
  ]
}
```