# VNet Encryption

## References

* <https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-encryption-overview>
* <https://hackcontrol.org/blog/what-is-dtls-and-how-is-it-used/>

## General

VNet encryption allows seamless encryption and decryption of traffic between Azure Virtual Machines by creating a DTLS tunnel.
Enables you to encrypt traffic between VMs and VMSS within the same virtual network.
It encrypts traffic between regionally and globally peered virtual networks.

## Requirements

Virtual Network encryption is supported on general-purpose and memory optimized virtual machine instance sizes including:

* General purpose workloads (D-Series v4 & v5)
* General purpose and memory intensive workloads (E-Series v4 & v5)
* Storage intensive workloads (LSv3)
* Memory intensive workloads (M-series)

Accelerated Networking must be enabled on the network interface of the virtual machine.

Encryption is only applied to traffic between virtual machines in a virtual network. Traffic is encrypted from a private IP address to a private IP address.

Traffic to unsupported Virtual Machines is unencrypted. Use Virtual Network Flow Logs to confirm flow encryption between virtual machines

The start/stop of existing virtual machines is required after enabling encryption in a virtual network.

## Limitation

In scenarios where a PaaS is involved, the virtual machine where the PaaS is hosted dictates if virtual network encryption is supported.
The virtual machine must meet the listed requirements.

For Internal load balancer, all virtual machines behind the load balancer must be a supported virtual machine SKU.

AllowUnencrypted is the only supported enforcement at general availability. DropUnencrypted enforcement will be supported in the future.

## Cost

No additional charges.
