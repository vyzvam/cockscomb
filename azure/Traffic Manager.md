# Azure Traffic Manager

https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-how-it-works
https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-performance-considerations
https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-monitoring
https://docs.microsoft.com/en-us/azure/traffic-manager/traffic-manager-faqs

# Objective:
Distribute traffic based on one or more traffic-routing methods
Continuous monitoring of endpoint health and automatic failover when endpoint fails

## How it works
Distribution of traffic according to one of several traffic-routing methods
Continuous monitoring of endpoint health and automatic failover when endpoints fail. The most important point to understand is that Traffic Manager works at the DNS level.
It sends DNS responses to direct clients to the appropriate service endpoint. Clients then connect to the service endpoint directly, not through Traffic Manager.
Therefore, Traffic Manager does not provide an endpoint or IP address for clients to connect to. If you want static IP address for your service, that must be configured at the service, not in Traffic Manager.

### Benefits
* Distribution of traffic according to one of several traffic-routing methods
* Continuous monitoring of endpoint health and automatic failover when endpoints fail

### Routing Methods:-
* **Priority** - Select Priority on a primary service endpoint for all traffic, provide backups in case the primary or the backup endpoints are unavailable.
* **Weighted** - Select Weighted to distribute traffic across a set of endpoints, either evenly or according to defined weights.
* **Performance** - Select Performance when you have endpoints in different geographic locations and o use the "closest" endpoint in terms of the lowest network latency.
* **Geographic** - Select Geographic directed to specific endpoints (Azure, External, or Nested) based on which geographic location their DNS query originates from.
    * This empowers Traffic Manager customers to enable scenarios where knowing a user’s geographic region and routing them based on that is important.
    * Examples include complying with data sovereignty mandates, localization of content & user experience and measuring traffic from different regions.
    * Multivalue - Select MultiValue for Traffic Manager profiles that can only have IPv4/IPv6 addresses as endpoints. all healthy endpoints are returned.
* **Multivalue**: Select MultiValue for Traffic Manager profiles that can only have IPv4/IPv6 addresses as endpoints. When a query is received for this profile, all healthy endpoints are returned.
* **Subnet** - To map sets of end-user IP address ranges to a specific endpoint within a Traffic Manager profile. The endpoint returned will be the one mapped for that request’s source IP address.

## Endpoint Monitoring

Configuration includes:
* Choosing protocols, Http, Https, TCP and choose port
* Path if Http / https selected
* Custom header setting
* Expected status code range
* Probing intervals and timeouts, and tolerated number of failures


## Performance Considerations

### Performance considerations for Traffic Manager
The only performance impact that Traffic Manager can have on your website is the initial DNS lookup.
A DNS request for the name of your Traffic Manager profile is handled by the Microsoft DNS root server that hosts the trafficmanager.net zone.
Traffic Manager populates, and regularly updates, the Microsoft's DNS root servers based on the Traffic Manager policy and the probe results. So even during the initial DNS lookup, no DNS queries are sent to Traffic Manager.

Traffic Manager is made up of several components:
* DNS name servers,
* an API service,
* the storage layer,
* and an endpoint monitoring service.

If a Traffic Manager service component fails, there is no effect on the DNS name associated with your Traffic Manager profile. The records in the Microsoft DNS servers remain unchanged. However, endpoint monitoring and DNS updating do not happen. Therefore, Traffic Manager is not able to update DNS to point to your failover site when your primary site goes down.

DNS name resolution is fast and results are cached. The speed of the initial DNS lookup depends on the DNS servers the client uses for name resolution.
Typically, a client can complete a DNS lookup within ~50 ms.
The results of the lookup are cached for the duration of the DNS Time-to-live (TTL). The default TTL for Traffic Manager is 300 seconds.

The Traffic Manager policy you choose has no influence on the DNS performance. However, a Performance routing-method can negatively impact the application experience. For example, if your policy redirects traffic from North America to an instance hosted in Asia, the network latency for those sessions may be a performance issue.

### Sample tools to measure DNS performance
* https://www.solvedns.com/dns-comparison/
* https://www.websitepulse.com/help/tools.php
* https://asm.ca.com/en/checkit.php
* https://tools.pingdom.com/
* https://www.whatsmydns.net/
* https://www.digwebinterface.com/

## Q&A
* Does Traffic Manager support "sticky" sessions?
Traffic Manager does not see the HTTP traffic between the client and the server.
Additionally, the source IP address of the DNS query received by Traffic Manager belongs to the recursive DNS service, not the client. Therefore, Traffic Manager has no way to track individual clients and cannot implement 'sticky' sessions. This limitation is common to all DNS-based traffic management systems and is not specific to Traffic Manager.

* Why am I seeing an HTTP error when using Traffic Manager?
Traffic Manager does not see HTTP traffic between client and server. Therefore, any HTTP error you see must be coming from your application. For the client to connect to the application, all DNS resolution steps are complete. That includes any interaction that Traffic Manager has on the application traffic flow.
The HTTP host header sent from the client's browser is the most common source of problems. Make sure that the application is configured to accept the correct host header for the domain name you are using. For endpoints using the Azure App Service, see configuring a custom domain name for a web app in Azure App Service using Traffic Manager.

* What is the performance impact of using Traffic Manager?
There is no performance impact incurred when using Traffic Manager once the connection is established.

It does require an additional DNS lookup to be inserted into the DNS resolution chain. The impact of Traffic Manager on DNS resolution time is minimal. Traffic Manager uses a global network of name servers, and uses anycast networking to ensure DNS queries are always routed to the closest available name server. In addition, caching of DNS responses means that the additional DNS latency incurred by using Traffic Manager applies only to a fraction of sessions.
The Performance method routes traffic to the closest available endpoint. The net result is that the overall performance impact associated with this method should be minimal. Any increase in DNS latency should be offset by lower network latency to the endpoint.

* Can I use Traffic Manager with a "naked" domain name?
Yes. To learn how to create an alias record for your domain name apex to reference an Azure Traffic Manager profile, see https://docs.microsoft.com/en-us/azure/dns/tutorial-alias-tm

*