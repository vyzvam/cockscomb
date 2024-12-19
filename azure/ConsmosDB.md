# CosmosDB

## Introduction

It is a `multi-model` database with `low latency` data access. It has instant `replication across region`.
It is a `fully managed serverless` architecture which `scales on demand`.
Various APIs available, SQL, MongoDB, Cassandra, Gremlin & Table

## Throughput

* Combine measure of CPU, Memory & IOPS
* Even measure regardless of chosen API
* Measured in `Request Units`
* Cost to read 1KB item is 1 Request unit
* Hourly billing

## Consistency Level

List in the order from stronger to weaker consistency. The Throuput is from lowest to highest

* Strong
* Bounded Staleness
* Session
* Consistent Prefix
* Eventual

## Create a cosmos DB

Create a `cosmosDB Account`

```c#
az cosmosdb create -n ssubcosmos -g ssublearn
```

Create a `Database`.

```c#
az cosmosdb sql database create --account-name ssubcosmos -g ssublearn -n ToDo

#command below will be deprecated
# az cosmosdb database create -n ssubcosmos -g ssublearn --db-name ToDo
```

Create `collections` (tables)

```c#
az cosmosdb sql container create -g ssublearn -a ssubcosmos -d ToDo -n ToDoList --partition-key-path "/'\$v'/category/'\$v'"
```

## Create console project

Create the `Console project`

```c#
mkdir testCosmos
cd testCosmos
dotnet new console
dotnet restore
```

Create a function to `Create Item`

```c#
#open the program.cs
#Create a CreateItem function
private static async Task CreateItem() {
    var cosmosUrl = "";
    var cosmosKey = "";
    var databaseName = "";

    CosmosClient client = new CosmosClient(cosmosUrl, cosmosKey);

    Database database = await client.CreateDatabaseIfNotExistAsync(databaseName);
    Container container = await database.CreateContainerIfNotExistAsync("MyContainer", "/partitionKeyPath", 400);

    dynamic testItem = { id = Guid.NewId().ToString(), partitionKeyPath = "MyTestPkValue", detail = "it's working"};

    var response = await container.CreateItemAsync(testItem);

}
```
