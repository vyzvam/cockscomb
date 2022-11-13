# AFD with PowerShell

## Azure Front Door with Powershell

### Re: <https://docs.microsoft.com/en-us/azure/frontdoor/quickstart-create-front-door-powershell>

### Create a resource group

New-AzResourceGroup -Name ssub-poc-afd -Location centralus

### Create first web app in Central US region

```c#
$webapp1 = New-AzWebApp -Name "ssubWebApp01" -Location centralus -ResourceGroupName ssub-poc-afd -AppServicePlan ssubWebAppPlan01
```

### Create second web app in South Central US region

```c#
$webapp2 = New-AzWebApp -Name "ssubWebApp02" -Location southcentralus -ResourceGroupName ssub-poc-afd -AppServicePlan ssubWebAppPlan02
```

### Create a unique name & create the frontend object

$fdname = "ssub-afd-$(Get-Random)"
$FrontendEndObject = New-AzFrontDoorFrontendEndpointObject -Name "frontendEndpoint1" -HostName $fdname".azurefd.net"

### Create backend objects that points to the hostname of the web apps

$backendObject1 = New-AzFrontDoorBackendObject -Address $webapp1.DefaultHostName
$backendObject2 = New-AzFrontDoorBackendObject -Address $webapp2.DefaultHostName

### Create a health probe object

$HealthProbeObject = New-AzFrontDoorHealthProbeSettingObject -Name "HealthProbeSetting"

### Create the load balancing setting object

```c#
$LoadBalancingSettingObject = New-AzFrontDoorLoadBalancingSettingObject -Name "Loadbalancingsetting" -SampleSize "4" -SuccessfulSamplesRequired "2" -AdditionalLatencyInMilliseconds "0"
```

### Create a backend pool using the backend objects, health probe, and load balancing settings

$BackendPoolObject = New-AzFrontDoorBackendPoolObject -Name "ssubBackendPool" -FrontDoorName $fdname -ResourceGroupName ssub-poc-afd -Backend $backendObject1,$backendObject2 -HealthProbeSettingsName "HealthProbeSetting" -LoadBalancingSettingsName "Loadbalancingsetting"

### Create a routing rule mapping the frontend host to the backend pool

$RoutingRuleObject = New-AzFrontDoorRoutingRuleObject -Name LocationRule -FrontDoorName $fdname -ResourceGroupName ssub-poc-afd -FrontendEndpointName "frontendEndpoint1" -BackendPoolName "ssubBackendPool" -PatternToMatch "/*"

### Creates the Front Door

New-AzFrontDoor -Name $fdname -ResourceGroupName ssub-poc-afd -RoutingRule $RoutingRuleObject -BackendPool $BackendPoolObject -FrontendEndpoint $FrontendEndObject -LoadBalancingSetting $LoadBalancingSettingObject -HealthProbeSetting $HealthProbeObject

### Gets Front Door in resource group and output the hostname of the frontend domain

```c#
$fd = Get-AzFrontDoor -ResourceGroupName ssub-poc-afd
$fd.FrontendEndpoints[0].Hostname
```

## cleanup

```c#
Remove-AzResourceGroup -Name ssub-poc-afd
```
