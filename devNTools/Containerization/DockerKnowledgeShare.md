# Docker knowledge share


## Running and checking a dotnet webapp
Run a container, image from docker hu.2 Operations on the container. Accessing the container

```c#
docker run -d -p 8080:80 --name sample mcr.microsoft.com/dotnet/core/samples:aspnetapp
docker run -d -p 8081:3000 --name nodejs vyzvam/nodejs
docker container stop sample
docker container rm id
docker container rm id -f
```

```c#
docker container logs sample
docker container inspec sample
docker container top sample
docker container stats sample
docker container exec -it  sample bash
```

## Creating an image: Extending to deploy new webapp

get sample from : git clone https://github.com/MicrosoftDocs/mslearn-hotel-reservation-system.git

create and build a dockerfile to run the project
```c#
docker build -t reservator .
docker image list

docker run -d -p 8080:80 -name reserve reservator
```

goto: localhost:8080/api/reservations/[x]

## Container on Azure

### Azure container registry

 azure cli
 ```c#
   az login
   az account set --subscription ????

   az acr create --name ssubcnreg --resource-group ssub --sku standard --admin-enabled true

   az acr credential show --name ssubcnreg
  ```
powershell
```c#
   New-AzureRmContainerRegistry -ResourceGroupName ssub -Name ssubcnreg -Sku Basic -EnableAdminUser

   Get-AzureRmContainerRegistryCredential -ResourceGroupName ssub -Name ssubcnreg
```

### Running on azure
```c#
docker login ssubcnrg.azurecr.io

docker tag reservator:v1 ssubcnreg.azurecr.io/reservator:v1
docker push ssubcnreg.azurecr.io/reservator:v1
az acr repository list --name ssubcnreg
az acr repository show --repository reservator --name ssubcnreg


az container create --resource-group ssub --name reservator01 --image ssubcnreg.azurecr.io/reservator:v1 --dns-name-label ssubsc --registry-username ssubcnreg --registry-password GFxW+VkF4o2wUAMlXhuVK3JkXFYNSITB

az container show --resource-group ssub --name reservator01 --query ipAddress.fqdn

```

## Local environment settings

az related
```c#
az login
az account set --subscription <name or id>
```

## Next step
Handson: azure containers
handson: AKS

What else for the future
Networking
- bridge / host: docker network or host network
- run or connect a container to a network