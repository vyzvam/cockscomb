# VNet Integration

## References

* <https://learn.microsoft.com/en-us/azure/app-service/overview-vnet-integration>
* <https://www.youtube.com/watch?v=5P14Q--Q9vE&ab_channel=JohnSavill%27sTechnicalTraining>

## Prelude

App Services can have protected inboud connections.

* Service endpoints - We can create and service endpoint and attach to a subnet where we can allow the subnet access to the app service.
  This creates an optimized route where it is routed via the MS backbone network.
* Application gateway - Can be used for other services outside of the subnet to be routed to the webapp
* Private endpoints - PEs attached to the subnet has direct access to the private ip of the webapp
* IP Address restrictions - Configure IP address restriction in app service

App Services can have protected outbound connections.

* Hybrid connection / Hybrid connection manager - TCP over port 443,
* Gateway required VNet integration - App services connects to the Gateway via a point to site VPN. Gateways in other regions can be used for this.
* Regional VNet integration - Dedicated subnet is used for this integration. This can talk to onPrem over ExpressRoute. Cannot connect to peered VNets.

## Summary

App Service virtual network integration feature enables apps to access resources in an non-internet-routable network,
in or through a virtual network, in peered vNet and OnPrem resources connected to the VNet via ExpressRoute or Site-to-Site VPM.

This feature is used in App Service dedicated compute pricing tiers. An app in ASE is already integrated with a virtual network and doesn't require you to configure virtual network integration feature.

Vnet Integration doesn't grant inbound private access to your app from the virtual network. Virtual network integration is used only to make outbound calls from your app into your virtual network.

## The virtual network integration feature

* Requires a supported Basic or Standard, Premium, Premium v2, Premium v3, or Elastic Premium App Service pricing tier.
* Supports TCP and UDP.
* Works with App Service apps, function apps and Logic apps.

Does not support mounting a drive, Windows Server Active Directory domain join and NetBIOS.

VNet integration supports connecting to a virtual network in the same region.
It enables your app to access:

* Resources in the virtual network you're integrated with.
* Resources in virtual networks peered to the virtual network your app is integrated with including global peering connections.
* Resources across Azure ExpressRoute connections.
* Service endpoint-secured services.
* Private endpoint-enabled services.

Can use the following Azure networking features:

* Network security groups (NSGs): You can block outbound traffic with an NSG that's placed on your integration subnet. The inbound rules don't apply because you can't use virtual network integration to provide inbound access to your app.
* Route tables (UDRs): You can place a route table on the integration subnet to send outbound traffic where you want.
* NAT gateway: You can use NAT gateway to get a dedicated outbound IP and mitigate SNAT port exhaustion.

## How it works

Apps in App Service are hosted on worker roles. It works by mounting virtual interfaces to the worker roles with addresses in the delegated subnet.
The virtual interfaces used aren't resources customers have direct access to.

App makes outbound calls through your virtual network. The outbound addresses that are listed in the app properties portal are the addresses still used by your app.
If your outbound call is to a virtual machine or private endpoint in the integration virtual network or peered virtual network, the outbound address is an address from the integration subnet. The private IP assigned to an instance is exposed via the environment variable, WEBSITE_PRIVATE_IP.

When all traffic routing is enabled, all outbound traffic is sent into your virtual network.
If all traffic routing isn't enabled, only private traffic (RFC1918) and service endpoints configured on the integration subnet is sent into the virtual network. Outbound traffic to the internet is routed directly from the app.

### A Windows App Service plan can have virtual network integrations with up to two subnets/virtual networks

For Windows App Service plans, the virtual network integration feature supports two virtual interfaces per worker which also mean two virtual network integrations per App Service plan.
The apps in the same App Service plan can only use one of the virtual network integrations to a specific subnet, meaning an app can only have a single VNet integration at a given time.
Linux App Service plans support only one virtual network integration per plan.

## Subnet requirements

VNet integration depends on a dedicated subnet. the subnet consumes five IPs from the start.
One address is used from the integration subnet for each App Service plan instance. If you scale your app to four instances, then four addresses are used.

When you scale up/down in size or in/out in number of instances, the required address space is doubled for a short period of time. The scale operation adds the same number of new instances and then deletes the existing instances. The scale operation affects the real, available supported instances for a given subnet size. Platform upgrades need free IP addresses to ensure upgrades can happen without interruptions to outbound traffic. Finally, after scale up, down, or in operations complete, there might be a short period of time before IP addresses are released.

Because subnet size can't be changed after assignment, use a subnet that's large enough to accommodate whatever scale your app might reach. You should also reserve IP addresses for platform upgrades. To avoid any issues with subnet capacity, use a /26 with 64 addresses. When you're creating subnets in Azure portal as part of integrating with the virtual network, a minimum size of /27 is required. If the subnet already exists before integrating through the portal, you can use a /28 subnet.

## Routes

You can control what traffic goes through the virtual network integration.
There are three types of routing to consider when you configure VNet integration.

* Application routing defines what traffic is routed from your app and into the virtual network.
* Configuration routing affects operations that happen before or during startup of your app. Examples are container image pull and app settings with Key Vault reference.
* Network routing is the ability to handle how both app and configuration traffic are routed from your virtual network and out.

Through application routing or configuration routing options, you can configure what traffic is sent through the virtual network integration. Traffic is only subject to network routing if it's sent through the virtual network integration.

### Application Routing

Applies to traffic that is sent from your app after it has been started.
You can either route all traffic or only private traffic (also known as RFC1918 traffic) into your virtual network.
This behaviour is configured through the outbound internet traffic setting.
If outbound internet traffic routing is disabled, your app only routes private traffic into your virtual network.
Outbound internet traffic must be enabled to route all your outbound app traffic into your virtual network.

Only traffic configured in application or configuration routing is subject to the NSGs and UDRs that are applied to your integration subnet.
When outbound internet traffic routing is enabled, the source address for your outbound traffic from your app is still one of the IP addresses that are listed in your app properties.
If you route your traffic through a firewall or a NAT gateway, the source IP address originates from this service.

### Configuration routing

Configure how parts of the configuration traffic are managed. By default, configuration traffic goes directly over the public route, but for the mentioned individual components, you can actively configure it to be routed through the virtual network integration.

#### Content share

Bringing your own storage for content in often used in Functions where content share is configured as part of the Functions app.
To route content share traffic through the VNet integration, you must ensure that the routing setting is configured.

In addition to configuring the routing, you must also ensure that any firewall or Network Security Group configured on traffic from the subnet allow traffic to port 443 and 445.

#### Container image pull

When using custom containers, you can pull the container over the VNet integration. Ensure that the routing setting is configured.

#### Backup/restore

App Service has built-in backup/restore, but if you want to back up to your own storage account, you can use the custom backup/restore feature. If you want to route the traffic to the storage account through the virtual network integration, you must configure the route setting. Database backup isn't supported over the virtual network integration.

#### App settings using Key Vault references

It attempt to get secrets over the public route. If the Key Vault is blocking public traffic and the app is using virtual network integration, an attempt is made to get the secrets through the virtual network integration.

### Network routing

You can use route tables to route outbound traffic from your app without restriction.
Common destinations can include firewall devices or gateways.
You can also use NSG to block outbound traffic to resources in your virtual network or the internet. An NSG that's applied to your integration subnet is in effect regardless of any route tables applied to your integration subnet.

Route tables and NSGs only apply to traffic routed through the virtual network integration.
Routes don't apply to replies from inbound app requests and inbound rules in an NSG don't apply to your app.
VNet integration affects only outbound traffic from your app.
To control inbound traffic to your app, use the access restrictions feature or private endpoints.

When configuring NSGs or route tables that applies to outbound traffic, Consider your application dependencies.
Application dependencies include endpoints that your app needs during runtime.
Besides APIs and services the app is calling, these endpoints could also be derived endpoints like certificate revocation list (CRL) check endpoints and identity/authentication endpoint, for example Microsoft Entra ID.
If you're using continuous deployment in App Service, you might also need to allow endpoints depending on type and language. Specifically for Linux continuous deployment, you need to allow oryx-cdn.microsoft.io:443. For Python you additionally need to allow files.pythonhosted.org, pypi.org.

When you want to route outbound traffic on-premises, you can use a route table to send outbound traffic to your Azure ExpressRoute gateway.
If you do route traffic to a gateway, set routes in the external network to send any replies back.
Border Gateway Protocol (BGP) routes also affect your app traffic.
If you have BGP routes from something like an ExpressRoute gateway, your app outbound traffic is affected.
Similar to user-defined routes, BGP routes affect traffic according to your routing scope setting.

### Service endpoints

Virtual network integration enables you to reach Azure services that are secured with service endpoints.

To access a service endpoint-secured service:

* Configure virtual network integration with your web app to connect to a specific subnet for integration.
* Go to the destination service and configure service endpoints against the integration subnet.

### Private endpoints

If you want to make calls to private endpoints, make sure that your DNS lookups resolve to the private endpoint:

* Integrate with Azure DNS private zones. When your virtual network doesn't have a custom DNS server, the integration is done automatically when the zones are linked to the virtual network.
* Manage the private endpoint in the DNS server used by your app. To manage the configuration, you must know the private endpoint IP address. Then point the endpoint you're trying to reach to that address by using an A record.
* Configure your own DNS server to forward to Azure DNS private zones.

### Azure DNS private zones

After your app integrates with your virtual network, it uses the same DNS server that your virtual network is configured with. If no custom DNS is specified, it uses Azure default DNS and any private zones linked to the virtual network.

### Limitations

* The feature is available from all App Service deployments in Premium v2 and Premium v3. It's also available in Basic and Standard tier but only from newer App Service deployments. If you're on an older deployment, you can only use the feature from a Premium v2 App Service plan. If you want to make sure you can use the feature in a Basic or Standard App Service plan, create your app in a Premium v3 App Service plan. Those plans are only supported on our newest deployments. You can scale down if you want after the plan is created.
* The feature isn't available for Isolated plan apps in an App Service Environment.
* You can't reach resources across peering connections with classic virtual networks.
* The feature requires an unused subnet that's an IPv4 /28 block or larger in an Azure Resource Manager virtual network.
* The app and the virtual network must be in the same region.
* The integration virtual network can't have IPv6 address spaces defined.
* The integration subnet can't have service endpoint policies enabled.
* The integration subnet can be used by only one App Service plan.
* You can't delete a virtual network with an integrated app. Remove the integration before you delete the virtual network.
* You can't have more than two virtual network integrations per Windows App Service plan. You can't have more than one virtual network integration per Linux App Service plan. Multiple apps in the same App Service plan can use the same virtual network integration.
* You can't change the subscription of an app or a plan while there's an app that's using virtual network integration.

### Access on-premises resources

No extra configuration is required for the virtual network integration feature to reach through your virtual network to on-premises resources. You simply need to connect your virtual network to on-premises resources by using ExpressRoute or a site-to-site VPN.

### Pricing details

The virtual network integration feature has no extra charge for use beyond the App Service plan pricing tier charges.

### Deleting the App Service plan or app before disconnecting the network integration

If app or the App Service is deleted plan without disconnecting the VNet integration first, No update/delete operations on the virtual network or subnet that was used for the integration with the deleted resource can be done.
A subnet delegation 'Microsoft.Web/serverFarms' remains assigned to your subnet and prevents the update/delete operations.

In order to do update/delete the subnet or virtual network again:

* Re-create the App Service plan and app (it's mandatory to use the exact same web app name as before).
* Navigate to Networking on the app in Azure portal and configure the virtual network integration.
* After the virtual network integration is configured, select the 'Disconnect' button.
* Delete the App Service plan or app.
* Update/Delete the subnet or virtual network.
