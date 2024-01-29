# Provisoin App Service with Private Endpoint using PowerShell

## Prepare Parameters

```c#
$prefix = "ssub"
$random = Get-Random
$resourceGroupName="$prefix-$random-rg"
$appName="$prefix-$random-app"
$appServicePlanName="$appName-asp"
$vNetName="$prefix-$random-vnet"
$location="southeastasia"
$privateEndpointSubnetName = "PESubnet"
```

## Create a resource group

```c#
New-AzResourceGroup -Name $resourceGroupName -Location $location
```

## Create an App Service plan in PremiumV2 tier & the web app

```c#
$appPlanParam = @{
   Name = $appServicePlanName
   Location = $location
   ResourceGroupName = $resourceGroupName
   Tier = "PremiumV2"
   NumberofWorkers = 1
   WorkerSize = "Small"
}
$asp = New-AzAppServicePlan @appPlanParam

$appParam = @{
    Name = $appName
    Location = $location
    AppServicePlan = $appServicePlanName
    ResourceGroupName = $resourceGroupName
}
$webApp = New-AzWebApp @appParam

```

## Create a Virtual Network with two subnets

```c#
$integrationsubnet = New-AzVirtualNetworkSubnetConfig -Name "integrationSubnet" -AddressPrefix "10.8.1.0/24"

$peSubnetParam = @{
    Name = $privateEndpointSubnetName
    AddressPrefix = "10.8.2.0/24"
    PrivateEndpointNetworkPoliciesFlag = "Disabled"
}
$privateendpointsubnet = New-AzVirtualNetworkSubnetConfig @peSubnetParam

$vNetParam = @{
    Name = $vNetName
    ResourceGroupName = $resourceGroupName
    Location = $location
    AddressPrefix = "10.8.0.0/16"
    Subnet = $integrationsubnet,$privateendpointsubnet
}
$virtualNetwork = New-AzVirtualNetwork @vNetParam

```

## Configure the Private Endpoint

```c#
$peConnectionParam = @{
    Name = "$($prefix)PrivateEndpointconnection"
    PrivateLinkServiceID = $webApp.Id
    GroupId = "sites"

}
$privateEndPointConnection = New-AzPrivateLinkServiceConnection @peConnectionParam


$subnet = $virtualNetwork | select -ExpandProperty subnets | Where-Object {$_.Name -eq $privateEndpointSubnetName}

$peParam = @{
    Name = "$($prefix)PrivateEndpoint"
    ResourceGroupName = $resourceGroupName
    Location  = $location
    Subnet = $subnet
    PrivateLinkServiceConnection = $privateEndPointConnection
}
$privateEndpoint = New-AzPrivateEndpoint @peParam

```

## Configure the Private DNS zone

```c#
$dnsZone = New-AzPrivateDnsZone -Name "privatelink.azurewebsites.net" -ResourceGroupName $resourceGroupName


$dnsLinkParam = @{
    Name = "$($prefix)DNSLink"
    ResourceGroupName = $resourceGroupName
    ZoneName = "privatelink.azurewebsites.net"
    VirtualNetworkId = $virtualNetwork.Id
}
$dnsLink = New-AzPrivateDnsVirtualNetworkLink @dnsLinkParam

$dnsConfig = New-AzPrivateDnsZoneConfig -Name "privatelink.azurewebsites.net" -PrivateDnsZoneId $dnsZone.ResourceId

$dnsZGParam = @{
    Name = "$($prefix)ZoneGroup"
    ResourceGroupName = $resourceGroupName
    PrivateEndpointName = $privateEndpoint.Name
    PrivateDnsZoneConfig  = $dnsConfig
}
$dnsZoneGroup = New-AzPrivateDnsZoneGroup @dnsZGParam

```
