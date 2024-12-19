# App Services Infrastructure

## References

* <https://github.com/projectkudu/kudu/wiki/Understanding-the-Azure-App-Service-file-system>
* <https://learn.microsoft.com/en-us/azure/app-service/operating-system-functionality#file-access>

## File system

### Persistent files

These are the web site's files.
They follow a structure, refer to <https://github.com/projectkudu/kudu/wiki/File-structure-on-azure>.
They are rooted in %HOME% directory.
For App Service on Linux and Web app for Containers, persistent storage is rooted in /home.

They are shared between all instances of your site (when you scale it up to multiple instances).
Internally, the way this works is that they are stored in Azure Storage instead of living on the local file system.

Free and Shared sites get 1GB of space, Basic sites get 10GB, Standard sites get 50GB.

### Temporary files

* %APPDATA% maps to %SYSTEMDRIVE%\local\AppData.
* %ProgramData% maps to %SYSTEMDRIVE%\local\ProgramData.
* %TMP% maps to %SYSTEMDRIVE%\local\Temp.
* %SYSTEMDRIVE%\local\DynamicCache for Dynamic Cache feature.

These files are not shared among site instances. Restarting the web app, will have all of these folders get reset to their original state.

The best practice: not to hardcode.
Instead of using paths like d:\home in the code use %HOME% (or %SystemDrive% if just the root path is needed).

For Free, Shared and Consumption (Functions) sites, there is a 500MB limit for all these locations together (i.e. not per-folder).

The limit applies to all sites in the same App Service Plan.
For instance, 10 sites in S2 App Service Plan, those sites (and their scm sites) will have a combined limit of 15 GB.
This same limit is applied on each VM instance - not a shared limit combined across instances.

Limit for other SKU.

SKU Family                  B1/S1/etc. B2/S2/etc. B3/S3/etc.
Basic, Standard, Premium        11 GB       15 GB      58 GB
PremiumV2, Isolated             21 GB       61 GB     140 GB

The Main site and the scm site do not share temp files. If you write some files there from your site, you will not see them from Kudu Console (and vice versa).

Limit and usage can be checked.
Go to "Diagnose and solve problems" -> "Best Practices", "Best Practices for Availability, Performance" -> "Temp File Usage On Workers".
the displayed usage and limits are per worker, and are aggregated across all apps in the same app service plan.

### Machine level read-only files

The Web App is able to access many standard Windows locations like %ProgramFiles% and %windir%. These files can never be modified by the Web App.

## AppService under the hood

* <https://petri.com/demystifying-azure-app-services/#:~:text=Inside%20each%20Azure%20region%20is,an%20%E2%80%9CApp%20Service%20stamp%E2%80%9D.>
* <https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections>

App Service requires an App Service plan (a virtual server), A plan can also reserve multiple servers and exist in a single Azure region.
Inside each Azure region is a data center with one or more App Service scale units inside.

A scale unit is a cluster of servers dedicated to a specific role, like running App Services, or running Azure Storage.
Microsoft also uses the term “stamp” to refer to a scale unit, as in an “App Service stamp”.

Every stamp will have some set of servers dedicated to administrative tasks which are managed by Azure:-

* Providing internal API endpoints for management
* Offering public FTP endpoints for publishing apps
* Providing resources for storing and caching your configuration data and coordinating with Azure SQL.

From our perspective, there are two important server roles inside of each scale unit.

* Web worker role. A server in the worker role is dedicated to run customer applications. Most of the servers in a scale unit are in the worker role.
* Front-end role, a layer 7 load balancer that understands the HTTP protocol. It terminates SSL connections, routes connections to workers, and provides simple round-robin load balancing when you have multiple instances in a plan.

Scale units are cost effective at scale because they are multi-tenanted.
Azure offers two types of App Service plans:-

* Shared resources describe above.
* Isolated plans and sometimes referred to as App Service Environments (ASEs), effectively gives you a dedicated scale unit.

### Outbound Connectivity

These are the connectivity methods:-

* Use the frontend IP address(es) of a LB for outbound via outbound rules, explicit port allocation. Proudction grade, but not at scale, rated OK.
* Associate a NAT gateway to the subnet. Dynamic, explicit Port allocation, Production grade, rated best.
* Assign a public IP to the virtual machine. Static, explicit Port allocation, Production grade, rated OK.
* Default outbound access Implicit port allocation. Not production grade, rated Worst

#### Using LB's frontend IP Address(es)

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

#### Associate NAT gateway to subnet

Azure NAT Gateway simplifies outbound-only Internet connectivity for virtual networks.
All outbound connectivity uses your specified static public IP addresses and is possible without LB or public IP addresses directly attached to virtual machines.
Fully managed and highly resilient, extensible, reliable, doesn't have the same concerns of SNAT port exhaustion and is the best method for outbound connectivity.

It takes precedence over other outbound connectivity methods, including a load balancer, instance-level public IP addresses, and Azure Firewall.

#### VM with public ip

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

#### Default outbound access

VMs created in a virtual network without explicit outbound connectivity defined are assigned a default outbound public IP address.
This IP address enables outbound connectivity from the resources to the Internet.
This method of access is not recommended as it is insecure and the IP addresses are subject to change.

### SNAT with AppService

Usually, an App Service web application needs to connect to  external endpoints, like SQL database, Redis cache or another Restful web service.
It cannot establish network connections to the external Internet endpoints directly.

This is because an App Service web application is hosted by one or some App Service worker instances. The worker instances are bounded inside the scale unit (stamp) of the site. They don’t have Internet IP addresses assigned and need to leverage their stamp’s load balancer to do the Source Network Address Translation, aka SNAT, in order to connect to external IP addresses.

#### How does SNAT work

refer to AppServices-06SNAT.md

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

#### SNAT Port exhaustion

SNAT LB is a shared resource between all of App Service sites in the same stamp. Including the web applications, WebJobs, Functions, telemetry services (Application Insights), etc.
