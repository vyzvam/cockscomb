# Asynchronous Search

## General

The async search API asynchronously ***executes a search*** request, ***monitor its progress***, and ***retrieve partial results*** as they become available.

These endpoints are available for the async searc API.

* Submit Search (`POST /{index}/_async_search`), executes a search query
* Get results (`GET /_async_search/{id}`), Retrieves result of a request based on id.
* Get Status (`GET /_async_search/status/{id}`), Gets status of the search
* Delete search (`DELETE /_async_search/{id}`)

## Submit async search

```c#
POST /sales*/_async_search?size=0
{
  "sort": [
    { "date": { "order": "asc" } }
  ],
  "aggs": {
    "sale_date": {
      "date_histogram": {
        "field": "date",
        "calendar_interval": "1d"
      }
    }
  }
}
```

Result

* `id`, Identifier of the search which is used later with other asynch API
* `is_partial` & `is_running`, Indicators of result state and if the search is still being executed.

## Get search results and search status

`GET /_async_search/abcd1234=`

`GET /_async_search/status/abcd1234=`

Status API result has a `completion_status` indicating the status code of the search

## Delete async search

`DELETE /_async_search/abcd1234=`