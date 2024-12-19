# Subnet Mask & CIDR

## Subnet mask

The first 3 octets is network id and the last octed is host id.

e.g: 192.0.2.1 with a subnet mask of 255.255.255.0, [192.0.2].[1].
192.0.2 is network id and 1 is host id.
There can be a total of 256 hosts with this subnet.
usable host of 254 since 0 is reserved for the network id and 255 for the broadcast id.

## CIDR (Classless Inter-Domain Routing) Notation

192.0.2.0/24, '24' represents the number of bits. 8 bits for each octet, the last octet can be used.
192.0.2.0/16, '16' represents the number of bits. 8 bits for each octet, the last 2 octets can be used. (this allows subnetting)
