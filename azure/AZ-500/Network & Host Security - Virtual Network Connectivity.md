# Network & Host Security - Virtual Network Connectivity

## Communication between machines

Consider 2 Vnet in place each having a VM.
Each of the VMs has defined public and private IP

Communication between the VMS via public IP goes over the internet, this may not be secure.

Communicating via the private ip adderess are more secure as it will happen over the azure backbone network.

### VNet Peering

Enabling Vnet Peering between VNets, traffic flows between the VMs located in the VNets via MS backbone infrastructure.
Traffic does not flow via internet and you get low latency, high bandwidth connection between the resources.

Vnet from either same region or cross regions can be connected.

#### Howto

##### Create a VNet

Goto Virtual Network
Create a virtual network:-

* specify name (e.g 'myvnet')
* address space (default 10.2.0.0/16)
* subscription
* resource group (e.g myrg)
* location (e.g West US)
* Subnet name and address range (default 10.2.0.0/24)

##### Create a new VM

* in the same resource group & region as the VNet created previously
* Choose the VNet created previously (with the default subnet)

##### Configure Peering

* Goto either of the VNet
* Settings->Peering
* Add a peering connection
* Provide a name
* Select the other VNet
* provide peering name for the other Vnet

Once done, the peering status would be 'connected'. Now you can access the VM from the other VM via it's private IP
As an example you can access the IIS web page by specifying private ip address.

### Site-to-Site VPN connections

This is for connection between a VM in a VNet and an onprem data center.
It is done by having a VPN connection tunnel (encrypted using IPsec IKE S2S).
This is done by setting up a VPN gateway.

### Service endpoints

Virtual Network (VNet) service endpoint provides secure and direct connectivity to Azure services over an optimized route over the Azure backbone network. Endpoints allow you to secure your critical Azure service resources to only your virtual networks. Service Endpoints enables private IP addresses in the VNet to reach the endpoint of an Azure service without needing a public IP address on the VNet.

#### Key benefits

##### Improved security for your Azure service resources

VNet private address spaces can overlap. You can't use overlapping spaces to uniquely identify traffic that originates from your VNet. Service endpoints enable securing of Azure service resources to your virtual network by extending VNet identity to the service. Once you enable service endpoints in your virtual network, you can add a virtual network rule to secure the Azure service resources to your virtual network. The rule addition provides improved security by fully removing public internet access to resources and allowing traffic only from your virtual network.

##### Optimal routing for Azure service traffic from your virtual network

Today, any routes in your virtual network that force internet traffic to your on-premises and/or virtual appliances also force Azure service traffic to take the same route as the internet traffic. Service endpoints provide optimal routing for Azure traffic.

##### Endpoints always take service traffic directly from your virtual network to the service on the Microsoft Azure backbone network

Keeping traffic on the Azure backbone network allows you to continue auditing and monitoring outbound Internet traffic from your virtual networks, through forced-tunneling, without impacting service traffic. For more information about user-defined routes and forced-tunneling, see Azure virtual network traffic routing.

##### Simple to set up with less management overhead

You no longer need reserved, public IP addresses in your virtual networks to secure Azure resources through IP firewall. There are no Network Address Translation (NAT) or gateway devices required to set up the service endpoints. You can configure service endpoints through a single selection on a subnet. There's no extra overhead to maintaining the endpoints.
