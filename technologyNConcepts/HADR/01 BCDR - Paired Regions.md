# Business continuity and disaster recovery (BCDR): Azure Paired Regions

## Paired Regions

An Azure geography is a defined area of the world that contains at least one Azure Region.
An Azure region containing one or more datacenters.

Each Azure region is paired with another region within the same geography, together making a regional pair.

The exception is Brazil South, which is paired with a region outside its geography.

Azure will serialize platform updates (planned maintenance) so that only one paired region will be updated at a time.
In addition, in the event of an outage affecting multiple regions at least one region in each pair will be prioritized for recovery.

## Benefits

### Physical isolation

Azure prefers at least 300 miles of separation between datacenters in a regional pair.
reduces the likelihood of natural disasters, civil unrest, power outages, or physical network outages affecting both regions at once.

### Platform-provided replication

Some services such as Geo-Redundant Storage provide automatic replication to the paired region.

### Region recovery order (Broad outage)

 In the event of a broad outage, recovery of one region is prioritized out of every pair. Applications that are deployed across paired regions are guaranteed to have one of the regions recovered with priority. If an application is deployed across regions that are not paired, recovery might be delayed – in the worst case the chosen regions may be the last two to be recovered.

## Sequential updates

 Planned Azure system updates are rolled out to paired regions sequentially (not at the same time) to minimize downtime.

## Data residency

 A region resides within the same geography as its pair in order to meet data residency requirements for tax and law enforcement jurisdiction purposes.

## Designing resilient applications for Azure
