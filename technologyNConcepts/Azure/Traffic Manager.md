# Azure Traffic Manager

## How it works

Distribution of traffic according to one of several traffic-routing methods
Continuous monitoring of endpoint health and automatic failover when endpoints fail. The most important point to understand is that Traffic Manager works at the DNS level

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
* **Subnet** - To map sets of end-user IP address ranges to a specific endpoint within a Traffic Manager profile. The endpoint returned will be the one mapped for that request’s source IP address.


## Endpoint Monitoring

Configuration includes:
* Choosing protocols, Http, Https, TCP and choose port
* Path if Http / https selected
* Custom header setting
* Expected status code range
* Probing intervals and timeouts, and tolerated number of failures

##