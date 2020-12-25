# App Service Plan


ref: https://docs.microsoft.com/en-gb/cli/azure/appservice/plan?view=azure-cli-latest

```c#
# Create a appservice plan
# '--hyper-v is only available for P1 and above
az appservice plan create -g ssublearn -l eastus -n ssubWinPlan --sku S1

az appservice plan show -g ssublearn -n ssubWinPlan

#create a app service
az webapp create -g ssublearn -p ssubWinPlan -n ssubAppOne

#create a dummy webapi ready to deploy
dotnet new webapi --name testApi --output .
dotnet build
dotnet publish

#go to the published folder
Compress-Archive *.* test.zip
az webapp deployment source config-zip -g ssublearn -n ssubAppOne --src test.zip
```


