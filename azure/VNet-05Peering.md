# VNet Peering

## References

* <https://www.youtube.com/watch?v=J4S6AxYNDtM&ab_channel=JohnSavill%27sTechnicalTraining>
* <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview>

## General

Enables seamless connection of two or more VNets in Azure where they appear as one for connectivity purposes.
The traffic between virtual machines in peered virtual networks uses the Microsoft backbone infrastructure. Traffic is routed through Microsoft's private network only. Peering accross region (Global network peering) is also supported.

### Benefits

A low-latency, high-bandwidth, private connection between resources in different virtual networks, across Azure subscriptions, Microsoft Entra tenants, deployment models, and Azure regions kept on the Microsoft backbone network with no public internet, gateway, or encryption required with no downtime to resources in either virtual network when creating the peering, or after the peering is created.

A VNet is confined to a particular subscription and region.
Other VNets could be in different subscription or region, can communicate with the VNet by

* SiteToSite VPN (VPN Gateway)
* ExpressRoute (ExpressRoute Circuit with each VNet having ExpressRoute gateway)
* Network Peering

Network peering is the recommended option for this scenario.
Network peering is where 2 Vnets have a peering relationship where workloads within those vnets will be able to communicate.
Peering with a VNet in a different region is a global vnet peering (slightly additional cost). VNet peering can only be done when there
is no IP address overlap.

## Multiple Peering

Vnet peering are non-transitive as in it has a one to one relationship, it cannot peer to the VNets that is peered at the target VNet.
There is a hub and spoke options where Spoke VNets can communicate via the hub. this is where all the spoke VNets are peered to the hub.
The hub has a virtual appliance such as a Azure Firewall or a NVA. UDRs are configured in each spoke VNet so that the network appliance in the hub will be able to route traffic accordingly.

The hub can also have a gateway transit for on-prem resources via ExpressRoute or Site-To-Site VPN

### Permissions

* <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering?tabs=peering-portal#permissions>

To establish peering, permission (from the link above) needs to be assigned.
On the target VNet, Peer action is required

## Cost

* <https://azure.microsoft.com/en-us/pricing/details/virtual-network/>
