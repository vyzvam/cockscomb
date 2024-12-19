# SNAT with App Service

* <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections>
* <https://4lowtherabbit.github.io/blogs/2019/10/SNAT/>

## Outbound Connectivity

These are the connectivity methods:-

* Use the frontend IP address(es) of a LB for outbound via outbound rules, explicit port allocation. Proudction grade, but not at scale, rated OK.

* Associate a NAT gateway to the subnet. Dynamic, explicit Port allocation, Production grade, rated best.
* Assign a public IP to the virtual machine. Static, explicit Port allocation, Production grade, rated OK.
* Default outbound access Implicit port allocation. Not production grade, rated Worst

### Using LB's frontend IP Address(es)

Outbound rules enables explicitly definition of SNAT (source network address translation) for a standard SKU public load balancer.
Allows to use the public IP or IPs of LB for outbound connectivity of the backend instances.

It enables:

* IP masquerading
* Simplifying your allowlists
* Reduces the number of public IP resources for deployment

With outbound rules, there is full declarative control over outbound internet connectivity.
It allows scaling and tuning to specific needs via manual port allocation.
Manually allocating SNAT port based on the backend pool size and number of frontendIPConfigurations can help avoid SNAT exhaustion.

Manually allocate SNAT ports either by "ports per instance" or "maximum number of backend instances".
If VMs used in the backend, it's recommended to allocate ports by "ports per instance" to get maximum SNAT port usage.

Calculate ports per instance as follows: Number of frontend IPs * 64K / Number of backend instances

If MVSS is in the backend, it's recommended to allocate ports by "maximum number of backend instances".
If more VMs are added to the backend than remaining SNAT ports allowed, scale out of Virtual Machine Scale Sets could be blocked, or the new VMs won't receive sufficient SNAT ports.

### Associate NAT gateway to subnet

Azure NAT Gateway simplifies outbound-only Internet connectivity for virtual networks.
All outbound connectivity uses your specified static public IP addresses and is possible without LB or public IP addresses directly attached to virtual machines.
Fully managed and highly resilient, extensible, reliable, doesn't have the same concerns of SNAT port exhaustion and is the best method for outbound connectivity.

It takes precedence over other outbound connectivity methods, including a load balancer, instance-level public IP addresses, and Azure Firewall.

### VM with public ip

Association by Public IP on VM's NIC and SNAT (Source Network Address Translation) isn't used.
Supported protocols are:-

* TCP (Transmission Control Protocol)
*UDP (User Datagram Protocol)
*ICMP (Internet Control Message Protocol)
* ESP (Encapsulating Security Payload)

Azure uses the public IP assigned to the IP configuration of the instance's NIC for all outbound flows.
The instance has all ephemeral ports available. It doesn't matter whether the VM is load balanced or not.
This scenario takes precedence over the others, except for NAT Gateway.
A public IP assigned to a VM is a 1:1 relationship (rather than 1: many) and implemented as a stateless 1:1 NAT.

### Default outbound access

VMs created in a virtual network without explicit outbound connectivity defined are assigned a default outbound public IP address.
This IP address enables outbound connectivity from the resources to the Internet.
This method of access is not recommended as it is insecure and the IP addresses are subject to change.

## SNAT with AppService

Usually, an App Service web application needs to connect to  external endpoints, like SQL database, Redis cache or another Restful web service.
It cannot establish network connections to the external Internet endpoints directly.

This is because an App Service web application is hosted by one or some App Service worker instances. The worker instances are bounded inside the scale unit (stamp) of the site. They don’t have Internet IP addresses assigned and need to leverage their stamp’s load balancer to do the Source Network Address Translation, aka SNAT, in order to connect to external IP addresses.

## How does SNAT work

Ports are used to generate unique identifiers used to maintain distinct flows. The internet uses a five-tuple to provide this distinction.

If a port is used for inbound connections, it has a listener for inbound connection requests on that port and can't be used for outbound connections.
To establish an outbound connection, an ephemeral port is used to provide the destination with a port on which to communicate and maintain a distinct traffic flow.

Every IP address has 65,535 ports. Each port can either be used for inbound or outbound connections for TCP and UDP. When a public IP address is added as a frontend IP to a load balancer, 64,000 ports are eligible for SNAT.

Each port used in a load balancing or inbound NAT rule consumes a range of eight ports from the 64,000 available SNAT ports.
This usage reduces the number of ports eligible for SNAT, if the same frontend IP is used for outbound connectivity. If load-balancing or inbound NAT rules consumed ports are in the same block of eight ports consumed by another rule, the rules don't require extra ports.

TCP protocol for instance, SNAT works in the following steps:

* App Service application sends a TCP package to an Internet IP address. The source IP address and port number of the package is internal.

* The TCP package is routed from a worker instance to the SNAT load balancer. SNAT changes the source IP and port of the TCP package into its own ones and sends it out to the Internet.

* It also keeps a record of the following mapping for each flow, e.g:-
  Worker instance IP address: 10.0.5.60:51014
  LB IP address: 13.76.245.72:12481
  External endpoint IP address: 52.189.232.180:80

* The Internet server receives the TCP package. Later when it sends back any package, it uses the IP address and port of the load balancer, as the destination of the package.

* When the load balancer receives a package, it changes the destination IP and port to the ones of the worker instance, and routed back to the worker instance.

### Default SNAT

When a VM creates an outbound flow, Azure translates the source IP address to an ephemeral IP address. This translation is done via SNAT.
If using SNAT without outbound rules via a public load balancer, SNAT ports are pre-allocated as described in the following default SNAT ports allocation table.

When load balancing rules are selected to use default port allocation, or outbound rules are configured with "Use the default number of outbound ports", SNAT ports are allocated by default based on the backend pool size.
Backends will receive the number of ports defined by the table, per frontend IP, up to a maximum of 1024 ports.

E.g, with 100 VMs in a backend pool and only one frontend IP, each VM will receive 512 ports.
If a second frontend IP is added, each VM will receive an additional 512 ports.
As a result, adding a third frontend IP will NOT increase the number of allocated SNAT ports beyond 1024 ports.

The number of SNAT ports provided when default port allocation is leveraged can be computed as: MIN(# of default SNAT ports provided based on pool size * number of frontend IPs associated with the pool, 1024)

Pool size:Default SNAT Ports -> 1-50:1024, 51-100:512, 101-200:256, 201-400:128, 401-800:64, 801-1,000:32

### SNAT Port exhaustion

Every connection to the same destination IP and destination port uses a SNAT port.
This connection maintains a distinct traffic flow from the backend instance or client to a server and gives the server a distinct port on which to address traffic. Without this process, the client machine is unaware of which flow a packet is part of.

e.g, with TCP destination  of 23.53.254.142:443, without SNAT ports for the return traffic, the client has no way to separate one query result from another.

Outbound connections can burst. A backend instance can be allocated insufficient ports. Use connection reuse functionality within your application. Without connection reuse, the risk of SNAT port exhaustion is increased.

New outbound connections fails when port exhaustion occurs. Connections succeed when a port becomes available.
This exhaustion occurs when the 64,000 ports from an IP address are spread thin across many backend instances.

A load balancer uses a single SNAT port for every destination IP and port. This multiuse enables multiple connections to the same destination IP with the same SNAT port. This multiuse is limited if the connection isn't to different destination ports.

For UDP connections, the load balancer uses a port-restricted cone NAT algorithm, which consumes one SNAT port per destination IP whatever the destination port.
A port is reused for an unlimited number of connections and is only reused if the destination IP or port is different.

* When a connection is idle with no new packets being sent, the ports will be released after 4 – 120 minutes. Can be configured via outbound rules.
* Each IP address provides 64,000 ports that can be used for SNAT.
* Each port can be used for both TCP and UDP connections.
* A UDP SNAT port is needed whether the destination port is unique or not. For every UDP connection to a destination IP, one UDP SNAT port is used.
* A TCP SNAT port can be used for multiple connections to the same destination IP provided the destination ports are different.
* SNAT exhaustion occurs when a backend instance runs out of given SNAT Ports. A load balancer can still have unused SNAT ports. If a backend instance’s used SNAT ports exceed its given SNAT ports, it's unable to establish new outbound connections.
* Fragmented packets are dropped unless outbound is through an instance level public IP on the VM's NIC.
* Secondary IP configurations of a network interface don't provide outbound communication (unless a public IP is associated to it) via a load balancer.

SNAT LB is a shared resource between all of App Service sites in the same stamp. Including the web applications, WebJobs, Functions, telemetry services (Application Insights), etc.

A typical App Service stamp has 5 outbound IP addresses for its SNAT load balancer.
These ports are shared by all instances inside a stamp.

e.g: 65536 * 5 / 2000 instances = 160 SNAT Port per instance
