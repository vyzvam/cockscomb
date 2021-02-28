# Event Grid 

## Create an Event Grid 
```c#
# Create a appservice plan
# '--hyper-v is only available for P1 and above
az appservice plan create -g ssublearn -l eastus -n ssubWinPlan --sku S1

az appservice plan show -g ssublearn -n ssubWinPlan

# Create a app service
az webapp create -g ssublearn -p ssubWinPlan -n ssubAppOne
```
## Create a webapi project.
```c#
# Create a dummy webapi ready to deploy
dotnet new webapi --name testApi --output .
dotnet build

# Run and test the site
# Check site on browser, e.g http://localhost:5000/weatherforecast
dotnet run
```
## deploy to azure website
```c#
# Publish
dotnet publish

# Go to the published folder
# create a zip file
# deploy to azure web app
Compress-Archive *.* testApi.zip
az webapp deployment source config-zip --src testApi.zip -g ssublearn -n ssubAppOne

#browse the site (append /weatherforecast in the url)
az webapp browse -g ssublearn -n ssubAppOne

#logs
az webapp log show -g ssublearn -n ssubAppOne
az webapp log tail -g ssublearn -n ssubAppOne
```

## Deploy from local git repo or Git repo service (e.g GitHub)
Note: this would mean that you don't have to publish and compress your code
```c#
# Deploy from git repo
az webapp deployment source config -g ssublearn -n ssubAppOne --repo-url https://github.com/vyzvam/testApi --branch main --manual-integration

#Deploy from local git
# add a deployment user
az webapp deployment user set --user-name <username> --password <password>

# get the git url from azure
az webapp deployment source config-local-git -g ssublearn -n ssubAppOne

# add a remote reference in the local git repo
git remote add azure https://<username>@ssubappone.scm.azurewebsites.net/ssubAppOne.git

# push repo to azure
git push azure
```

## Do the same for linux environment (Currently unable to deploy linux plan)
```c#
# Create a appservice plan
az appservice plan create -g ssublearn -l eastus -n ssubLinuxPlan --is-linux

az appservice plan show -g ssublearn -n ssubLinuxPlan

# Create a app service
az webapp create -g ssublearn -p ssubLinuxPlan -n ssubAppTwo
```




## Prepare web app for containerized deployment

Create a `Dockerfile` and add the contents below
```c#
# Use the .net core 3.1 SDK Container image
FROM mcr.microsoft.com/dotnet/core/3.1-alpine AS build

#Change current working directory
WORKDIR /app

# Copy existing files from host machine
COPY . ./

# Publish application to out folder
RUN dotnet publish --configuration release --output out

# Start container by running application dll
ENTRYPOINT ["dotnet", "out/testApi.dll"]
```

## Create ACR and push image
```c#
az acr create -g ssublearn -l eastus --sku standard -n ssubAcr --admin-enabled true

az acr build --registry ssubAcr --image testapi:latest .
```

## Create Web app
```c#
az group create -n ssublearnlinux -l eastus

az appservice plan create -g ssublearnlinux -l eastus -n ssubPlanLinux

az webapp create -g ssublearnlinux -p ssubPlanLinux -n ssubAppTwo --deployment-container-image-name ssubacr.azurecr.io/testapi:latest

# You can change the container config (optional)
az webapp config container set --docker-custom-image-name $ContainerPath -n ssubAppTwo -g ssubleanLinux
```

web app log processes



continuous deployment (.deployment)



