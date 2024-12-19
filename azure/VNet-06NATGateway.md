# Azure NAT Gateway

## References

* <https://learn.microsoft.com/en-us/azure/nat-gateway/nat-overview>
* <https://www.youtube.com/watch?v=c685a1CiaIs&ab_channel=JohnSavill%27sTechnicalTraining>

## Summary

A fully managed & highly resilient Network Address Translation service.
All instances in a private subnet connect outbound to the internet while remaining fully private.
Only packets arriving as response packets to an outbound connection can pass through a NAT gateway.
Provides dynamic SNAT port functionality to automatically scale outbound connectivity and reduce the risk of SNAT port exhaustion.

A non-zonal or zonal NAT Gateway is setup by assigning a public IP or a public IP prefix, then configure a VNet subnet to use the NAT gateway.

## Security

Private instances within a subnet don't need public IP addresses to reach the internet. They can reach external sources outside the virtual network by source network address translating (SNAT) to NAT gateway's static public IP addresses or prefixes.

It Can provide a contiguous set of IPs for outbound connectivity by using a public IP prefix.
Destination firewall rules can be configured based on this predictable IP list.

## Resiliency

It doesn't depend on individual compute instances such as VMs or a single physical gateway device.
A NAT gateway always has multiple fault domains and can sustain multiple failures without service outage.
Software defined networking makes a NAT gateway highly resilient.

## Scalability

Scaled out from creation & Azure manages the operation of NAT gateway.
All subnets in a virtual network can use the same NAT gateway resource.
Outbound connectivity can be scaled out by assigning up to 16 public IP addresses or a /28 size public IP prefix to NAT gateway.
When a NAT gateway is associated to a public IP prefix, it automatically scales to the number of IP addresses needed for outbound.

## Performance

Is a software defined networking service.
Each NAT gateway can process up to 50 Gbps of data for both outbound and return traffic.

A NAT gateway doesn't affect the network bandwidth of your compute resources.

* Support up to 50,000 concurrent connections per public IP address to the same destination endpoint over the internet for TCP and UDP.
* Processes 1M packets/sec and scale up to 5M packets/sec.
* Supports up to 2 million total number of connections at any given time. While it's possible that the NAT gateway can exceed 2 million connections, there is increased risk of connection failures.

## Limitations

Basic load balancers and basic public IP addresses aren't compatible with NAT gateway.
Use standard SKU load balancers and public IPs instead.
NAT gateway doesn't support ICMP
IP fragmentation isn't available for NAT Gateway.
Doesn't support Public IP addresses with routing configuration type internet.
Public IPs with DDoS protection enabled are not supported with NAT gateway.

## Metrics and alerts

Multi-dimensional metrics and alerts through Azure Monitor.
You can use these metrics to monitor and manage your NAT gateway and to assist you in troubleshooting issues.

Network Insights: Azure Monitor Insights provides you with visual tools to view, monitor, and assist you in diagnosing issues with your NAT gateway resource. Insights provide you with a topological map of your Azure setup and metrics dashboards.

Metrics such as Bytes, Packets, Dropped packets, SNAT connection count, Total SNAT connection count & data path availability.

## Pricing (2024/02/07)

Resource Hours $0.045 per hour
Data Processed $0.045 per GB
