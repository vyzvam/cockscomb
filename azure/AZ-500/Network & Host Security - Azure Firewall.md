# Network & Host Security - Azure Firewall

* A fully managed cloud based network security service.
* Used to protect you resources in Azure VNet.
* Create and enforce application and network connectivity policies.
* Automatically scales up based on demand.

## Example #1

We have JumpVM and MyVM

Create a subnet in the Vnet to be configured with Azure Firewall.
Name the subnet "AzureFirewallSubnet".

Goto->Firewall->Create

* Choose the Vnet
* Create a new public IP

Goto->Route Table->Create->Goto->Routes->Add Route

* Add a route name
* Address prefix 0.0.0.0/0
* Next hop type: Virtual appliance
* Next hop address: private ip address of the firewall

Goto->Subnets->Associate->Choose the VNet->Choose default subnet

Goto->TheFirewall->Rules->Add application rule collection->specify the target FQDNs

## Azure Firewall Manager

* A security management server that provides central security policies.
* Apply policies to secured virtual hub or your own implementation of hub virtual network
* Can create global security policies that can be applied to multiple secured virtual hubs
* Can integrate to third-party security as service providers.

Goto->VNet->Create->Enable firewall witht public IP address

Goto->Firewall Manager->Azure firewall policies->Create
Add a rule collection
Goto->Hub virtual network->Convert Vnet->Select the Vnet->Apply firewall policy->