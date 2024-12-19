# Azure FrontDoor (AFD) with PowerShell

## References

* <https://docs.microsoft.com/en-us/azure/frontdoor/quickstart-create-front-door-powershell>

## Summary

## Create a resource group

```c#

$resourceGroupName = "ssub-poc-afd"
$primaryRegion = centralus

New-AzResourceGroup -Name $resourceGroupName -Location $primaryRegion
```

## Create the web apps

```c#
$secondaryRegion = southcentralus
$primaryAppName = "ssubWebAppPrimary"
$primaryAppPlanName = "$($primaryAppName)-Plan"
$secondaryAppName = "ssubWebAppSecondary"
$secondaryAppPlanName = "$($secondaryAppName)-Plan"

// Create first web app in Central US region
$webapp1 = New-AzWebApp -Name $primaryAppName -Location $primaryRegion -ResourceGroupName $resourceGroupName -AppServicePlan $primaryAppPlanName

// Create second web app in South Central US region
$webapp1 = New-AzWebApp -Name $secondaryAppName -Location $secondaryRegion -ResourceGroupName $resourceGroupName -AppServicePlan $secondaryAppPlanName
```

## Provisioning of AFD

```c#
// Create a unique name & create the frontend object
$fdname = "$($resourceGroupName)-afd-$(Get-Random)"
$endpointName = "frontendEndpoint1"
$endpointObject = New-AzFrontDoorFrontendEndpointObject -Name $endpointName -HostName $fdname".azurefd.net"

// Create backend objects that points to the hostname of the web apps
$backendObject1 = New-AzFrontDoorBackendObject -Address $webapp1.DefaultHostName
$backendObject2 = New-AzFrontDoorBackendObject -Address $webapp2.DefaultHostName

// Create a health probe object
$probeSettingName = "HealthProbeSetting"
$healthProbeObject = New-AzFrontDoorHealthProbeSettingObject -Name $probeSettingName

// Create the load balancing setting object
$lbSettingName = "LoadBalancingSetting"
$loadBalancingSettingObject = New-AzFrontDoorLoadBalancingSettingObject -Name $lbSettingName -SampleSize "4" -SuccessfulSamplesRequired "2" -AdditionalLatencyInMilliseconds "0"

// Create a backend pool using the backend objects, health probe, and load balancing settings
$backendPoolName = "ssubBackendPool"

$poolParam = @{
    Name = $backendPoolName
    FrontDoorName = $fdname
    ResourceGroupName = $resourceGroupName
    Backend = $backendObject1,$backendObject2
    HealthProbeSettingsName = $probeSettingName
    LoadBalancingSettingsName = $lbSettingName
}
$backendPoolObject = New-AzFrontDoorBackendPoolObject @poolParam

// Create a routing rule mapping the frontend host to the backend pool
$routingRuleParam @{
    Name = LocationRule
    FrontDoorName = $fdname
    ResourceGroupName = $resourceGroupName
    FrontendEndpointName = $endpointName
    BackendPoolName = $backendPoolName
    PatternToMatch = "/*"
}

$RoutingRuleObject = New-AzFrontDoorRoutingRuleObject @routingRuleParam

// Creates the Front Door
$fdParam = @{
    Name = $fdname
    ResourceGroupName = $resourceGroupName
    RoutingRule = $RoutingRuleObject
    BackendPool = $backendPoolObject
    FrontendEndpoint = $endpointObject
    LoadBalancingSetting = $loadBalancingSettingObject
    HealthProbeSetting = $healthProbeObject
}
New-AzFrontDoor @fdParam

```

## Gets Front Door in resource group and output the hostname of the frontend domain

```c#
$fd = Get-AzFrontDoor -ResourceGroupName $resourceGroupName
$fd.FrontendEndpoints[0].Hostname
```

## cleanup

```c#
Remove-AzResourceGroup -Name $resourceGroupName
```
