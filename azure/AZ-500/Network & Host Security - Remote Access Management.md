# Remote Access Management

## Scenario #1

There are 3 VMs in a VNet. They can be in the same or different subnet.

* VM1 (PubIP: 40.122.150.87, PriIP: 10.0.0.4): Web server
* VM2 (PubIP: 70.87.190.56, PriIP: 10.0.1.4): Middle tier solution
* VM3 (PubIP: 12.30.6.7, PriIP: 10.0.2.4): Database server

In order to access these servers from you machine, you may configure an NSG rule to allow access to all the 3 VMs. But this
is not a secure practice.

### How to secure you resources

Remove public ip address for the middle tier and database solution.
Introduce a new VM (Jump server). you can configure to remote to the jump server then remote to any of the 3 VMs.

You may also remove the public ip for the web server and configure a load balancer to direct traffic to the web server.

### Example

Goto->VM2->Networking->Network Interface->IP Configuration->Select the IP Config->Disable public IP Address
Goto->TheVNet->Subnets->Create new subnet->Name as "jumpsubnet"
Goto->VM->Create new VM (JumpVM)->Choose the "Jumpsubnet"->Make sure public ip is assigned

Goto->JumpVM->Networking->
Select RDP rule in the inboudport rules->Change source from any to Ip address->specify the IP of the workstation/local machine
Change destination from any to the jumpserver ipaddres

Goto->VM2->Networking->RDP rule of inbound rule->specify the source Ip as the jumpserver private ip

RDP into->Jumpserver->RDP into VM2 using the VM2 private ip address.









