# Provision App Service with Private Endpoint using PowerShell

## Create a resource group

```c#
$prefix = "ssub"
$random = Get-Random
$resourceGroupName="$prefix-$random-rg"
$location="southeastasia"

New-AzResourceGroup -Name $resourceGroupName -Location $location
```

## Create an App Service plan in PremiumV2 tier & the web app

```c#
$appName="$prefix-$random-app"
$appServicePlanName="$appName-asp"

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
$defaultSubnetName = "integrationSubnet"
$privateEndpointSubnetName = "PESubnet"
$vNetName="$prefix-$random-vnet"

$integrationSubnet = New-AzVirtualNetworkSubnetConfig -Name $defaultSubnetname -AddressPrefix "10.10.1.0/24"

$peSubnetParam = @{
    Name = $privateEndpointSubnetName
    AddressPrefix = "10.10.2.0/24"
    PrivateEndpointNetworkPoliciesFlag = "Disabled"
}
$peEndpointSubnet = New-AzVirtualNetworkSubnetConfig @peSubnetParam

$vNetParam = @{
    Name = $vNetName
    ResourceGroupName = $resourceGroupName
    Location = $location
    AddressPrefix = "10.10.0.0/16"
    Subnet = $integrationSubnet,$peEndpointSubnet
}
$virtualNetwork = New-AzVirtualNetwork @vNetParam

```

## Enable VNet Integration

```c#
$webApp = Get-AzResource -ResourceType Microsoft.Web/sites -ResourceGroupName $resourceGroupName -ResourceName $appName
$webApp.Properties.virtualNetworkSubnetId = $virtualNetwork.subnets[0].Id
$webApp.Properties.vnetRouteAllEnabled = 'true'
$webApp | Set-AzResource -Force
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
