# Event Hub

## Create a storage account

```c#
# create storage account
az storage account create -g ssublearn -l eastus -n ssubsa --sku Standard_LRS

#create a container
az storage container create --account-name ssubsa -n checkpoint

# Get connection string from storage account
connectionString=$(az storage account show-connection-string --n ssubsa -g ssublearn)
```

## Create Event Grid

```c#
az eventhubs namespace create -g ssublearn -n ssubnspace -l eastus --sku Standard --enable-auto-inflate --maximum-throughput-units 5

az eventhubs eventhub create -g ssublearn --namespace-name ssubnspace -n ssubhub --message-retention 4 --partition-count 3

# Create a shared access policy for sending
az eventhubs eventhub authorization-rule create -g ssublearn --namespace-name ssubnspace --eventhub-name ssubhub --name HubSender --rights send

# Retrieve the connectionstring
SendConnectionString=$(az eventhubs eventhub authorization-rule keys list -g ssublearn --namespace-name ssubnspace --eventhub-name ssubhub --name HubSender --query '{connection:primaryConnectionString}' -o tsv)

# Create a shared access policy for listening
az eventhubs eventhub authorization-rule create -g ssublearn --namespace-name ssubnspace --eventhub-name ssubhub --name HubListener --rights listen

# Retrieve the connectionstring
ListenConnectionString=$(az eventhubs eventhub authorization-rule keys list -g ssublearn --namespace-name ssubnspace --eventhub-name ssubhub --name HubListener --query '{connection:primaryConnectionString}' -o tsv)
```

## Create a .net project for sending messages

```c#
# Create a console app
mkdir EvenHubProducer
cd EventHubProducer
dotnet new console
dotnet add package Azure.Messaging.EvenHubs
dotnet add package Azure.Messaging.EvenHubs.Producer
dotnet restore
```

```c#
#Add code to Program.cs
#add these codes in the Program class
privant const string connectionString = "";
privant const string eventHubName = "ssubhub";

static async Task Main() {

    await using (var producerClient = new EventHubProducerClient(connectionString, eventHubName)) {

        using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();

        eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes("First Event")));
        eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes("Second Event")));
        eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes("Third Event")));

        await producerClient.SendAsync(eventBatch);
        Console.Writeline("A batch of 3 event have been published.");
    }
}
```

## Create a .net project for receiving messages

```c#
# Create a console app
# make sure you are not in the folder of the previous project

mkdir EvenHubListener
cd EventHubListener
dotnet new console
dotnet add package Azure.Messaging.EvenHubs
dotnet add package Azure.Messaging.EvenHubs.Processor
dotnet add package Azure.Storage.Blobs
dotnet restore
```

```c#
#Add code to Program.cs
#add these codes in the Program class
private const string connectionString = "<connectionString";
private const string eventHubName = "ssubhub";
private const string blobStorageConnectionString = "<saconnectionString>";
private const string blobContainerName = "checkpoint";

static async Task Main() {

    string consumerGroup = EventHubConsumerClient.DefaultConsumerGroupName;

    BlobContainerClient storageClient = new BlobContainerClient(blobStorageConnectionString, blobContainerName);

    EventProcessorClient processor = New EventProcessorClient(storageClient, consumerClient, connectionString, eventHubName);

    processor.ProcessEventAsync += ProcessEventHandler;
    processor.ErrorEventAsync += ProcessErrorEventHandler;

    await processor.StartProcessingAsync();
    await Task.Delay(Timespan.FromSeconds(10));
    await processor.StopProcessingAsync();

}

static async Task ProcessEventHandler(ProcessEventArgs eventArgs) {
    Console.WriteLine("tReceived event:  {0}", Encoding.UTF8.GetString(eventArgs.Data.Body.ToArray()));

    await eventArgs.UpdateCheckPointAsync(eventArgs.CancellationToken);
}

static async Task ProcessErrorEventHandler(ProcessErrorEventArgs eventArgs) {

    Console.WriteLine($"\tPartision '{eventArgs.PartitionId}': An unhandled exception was encoutered");

    Console.WriteLine(eventArgs.Exception.Message);
    return Task.CompletedTask;
}
```
