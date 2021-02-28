# Function App


## Create Storage Account
https://docs.microsoft.com/en-gb/cli/azure/storage/account?view=azure-cli-latest#az_storage_account_create
```c#
# create storage account
az storage account create -g ssublearn -l eastus -n ssubsa --sku Standard_LRS
# Get connection string from storage account
connectionString=$(az storage account show-connection-string --n ssubsa -g ssublearn)
```

## Create a function app
```c#
az functionapp create -g ssublearn --consumption-plan-location eastus -n ssubFunc --os-type Linux --runtime dotnet --functions-version 3 --storage-account ssubsa
```

## Create a function project
```c#

# Install Azure Functions Core Tools
choco install azure-functions-core-tools-3 --params "'/x64'"

# Create a function app
func init --worker-runtime dotnet

# Update the value of AzureWebJobsStorage in local.settings.json with the connection string


#create a http trigger
func new --template "HTTP Trigger" --name "Hello"

#the output will provide the url and available path
func start --build

#verify the function
#you should get a 200 response after issuing 'get'
httprepl <ur><path>
cd api
cd Hello
get
```

## Create function to manage storage queues
```c#
func new --template "Queue Trigger" --name "QueueTrigger"

func extensions install --package Azure.Storage.Queues --version 12.0.0

```

