# Network & Host Security - Network Security Groups

## Basic

NSG are used to filter traffic to and from Azure resources in an Az VNet
It consists of rules to allow or deny inbound and outbound traffic.

A rule nas name, Priority, Source or destination, protocol, Direction (inbound/outbound), port range & Action(allow/deny)

Goto->theVM->Setting->Networking
You can configure the inbound traffice rule & outbound traffic rule.

## Application security groups

### Example #1

We have VM1 and VM2 in the same RG & Region. They are also in the same VNet and subnet.

Goto->Application security Group->Create
Choose the resource group and the region
Goto->VM1->Networking->Application security groups->Configure the Application security group
Select the newly created ASG

Goto->VM2->inbout port rules->Add->select ASG in the source->and choose the newly created ASG

### Key limitations

* Can specify the ASG as either source or destination in a ASG Rule
* Can only specify one ASG and not multiple in the source or destination
* Once ASG is assigned to a VNet interface, that ASG can only be assigned to network interface in the same VNet