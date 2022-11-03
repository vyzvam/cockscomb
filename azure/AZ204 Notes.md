# Takeaways from Az204


### Creating storage account containers
### uploading blobs (images)
### connecting to SA and getting the sa, container & blob details

___
### creating a web app and configure connection to SA
### creating and deploying an asp.net app (API) to azure webapp
### creating an asp.net app (front-end) and configure to connect to AIP
### deploying an asp.net app (front-end) to azure webapp
___
### Create azure function project
### create http trigger function and test using httprepl
### create schedule trigger function (timer trigger)
### create a blob trigger function
### create SA and configure the connectionstring in function
### public project to azure functions
___
### get container details from azure SA using .net sdk
### create contianer using .net sdk
### get blob details using .net sdk
___
### create sql server
### create cosmos db
### create storage account and store images and sql server bacpac
### import database in to sql server
### create a .net web app and configure to connect to sql server
### create console app to get data from sql server and populate cosmos db
### update .net web app to connect to cosmosdb

___
## Create a VM

### create a console app to check ip
### create a dockerfile, create image
### create acr and push image to acr
### deploy container instance from acr
### deploy container instance from services

___
### creating ad app and accessing the details using MS SDK (Graph.Client & Microsoft.Identity.Client)

___
### creation function app that gets file content from storage account
### using keyvault for function app to get file from storage account
### need to enable principle (ad app created for function app)
### kv secret value need to follow a particular format "@Microsoft.KeyVault(SecretUri=*Secret Identifier*)"


___
## create web app httpapissub using docker

image: kennethreitz/httpbin:latest

test site get /xml

create api management prodapissub , company Contoso
create HTTPBin API:httpbin-api

add operation design:-
inboud op policy, header name:source, value:azure-api-mgmt, action:append

echo header op, backend tile override service url, append /headers

test echo header ,

ad get legacy data operation :get-legacy-data , GET /xml
test send

add policy in outbound processing , other policies

<outbound>
    <base />
    <xml-to-json kind="direct" apply="always" consider-accept-header="false" />
</outbound>

test send

___
create logic app and setup flow to list files from storage account
configure storage account with file share and upload json files
create api in api management and the json result listing the file

-----------------------------------

create event grid topic & a containerized web app : microsoftlearning/azure-event-grid-viewer:latest

create a .net project publish events using the Microsoft.Azure.EventGrid & Microsoft.Azure.EventGrid.Models

---------------------------

create queue in storage account

use azure.storage.queues library to get remove and add messages to the queue

---------------------------------


setup application insights

configure local web api project and use the instrumentation key to the app insights
uses these packages, Microsoft.ApplicationInsights, Microsoft.ApplicationInsights.AspNetCore & Microsoft.ApplicationInsights.PerfCounterCollector
provision web app and connect to the app insights
deploy the project to the app service
open the weatherforecast page in browser and observe the metrics in app insights
observe the live metrics in app insights while making the requests.

------------------------------------------

register microsoft.CDN provider in subscription

create a cdn profile

create media and video containers
create a web app

create cdn enpoints for media, video and web
configure web app to use media and video cdn endpoint



## Things to practice for Azure


1. Web Apps
   * Service plans
   * CORS in web apps (include "az webapp cors *" function)
   * Continuous deployment (github, .deployment)
   * Web App log processes
   * https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-linux-docker-aspnetcore
   * https://docs.microsoft.com/en-us/azure/app-service/manage-scale-up

2. VM
   * Enabling RDP


7. Function app with storage queues
   * Securing (Authenticate & Authorize)

10. Logic Apps

1. Event Hub
   * Setup in portal
   * Captures
   * Apache Avro
   * Create pub and sub scenarios
   * deploy using az
   * deploy using powershell

2. Storage Account
   * Setup for soft delete & snapshots
   * deploy using az
   * deploy using powershell
   * blob properties (https://docs.microsoft.com/en-us/azure/dms/dms-overview)


11. Event Grid
    * Filters
    * https://docs.microsoft.com/en-us/azure/dms/dms-overview
    * https://docs.microsoft.com/en-us/azure/event-grid/compare-messaging-services#comparison-of-services


15. Service Bus
    * Filters for subscribers
    * https://docs.microsoft.com/en-us/azure/service-bus-messaging/topic-filters

20. Notification Hub
    * https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-enterprise-push-notification-architecture
    *
3. Cosmos DB
   * Partitions and partition keys
   * Consistency
   * table creation (in az as well)
   * deploy using az
   * deploy using powershell
   * https://docs.microsoft.com/en-us/azure/dms/dms-overview


16. API Management
    * inbound and outbound policies
    * https://docs.microsoft.com/en-us/azure/api-management/api-management-sample-send-request
    * https://docs.microsoft.com/en-us/azure/api-management/api-management-howto-cache

19. Table storage

5. IAM related
   * dotnet core with storage accounts access
   * understand delegate and user_impersonation permissions
   * AD App manifest & approles


13. Integration service environment
    *

14. ACR and it's authentication
    * headless authentication


17. Redis
    * stale key removal
    * https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-best-practices
    * https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-overview

18. App Insights
   * https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-segmentation#the-users-sessions-and-events-segmentation-tool
   * https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-funnels
   * https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-impact
   * https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-retention
   * https://docs.microsoft.com/en-us/azure/azure-monitor/app/usage-flows

12. Azure Database Migration Service
    * https://docs.microsoft.com/en-us/azure/dms/dms-overview



## AZ 204 exam prep

Your Voucher Code is: MSP327770521


## sample questions
https://www.examtopics.com/exams/microsoft/az-204/


## Resources
http://asmaliza.com/az-204/
https://www.microsoft.com/en-us/videoplayer/embed/RE4IFBp



