# Well-Architected Framework (WAF)

## References

* <<https://learn.microsoft.com/en-us/azure/well-architected/>

## Summary

## Reliability Pillar

Apply reliability guidance to your architecture to make your workload resilient to malfunction and to ensure that it returns to a fully functioning state after a failure occurs.

## Design principals

<https://learn.microsoft.com/en-us/azure/well-architected/reliability/principles>

Outages and malfunctions are serious concerns for all workloads. A reliable workload must survive those events and continue to consistently provide its intended functionality.

It must be resilient so that it can detect, withstand, and recover from failures within an acceptable time period.
It must also be available so that users can access the workload during the promised time period at the promised quality level.

Workload architectures should have reliability assurances in application code, infrastructure, and operations.
Design choices shouldn't change the intent that's specified by business requirements. Such changes should be considered significant tradeoffs.

Start with the recommended approaches and justify the benefits for a set of requirements. After you set your strategy, drive actions by using the Reliability checklist.

### Design for business requirement

It must cover user experience, data, workflows, and characteristics that are unique to the workload.
The outcome of the requirements process must clearly state the expectations.
The goals must be achievable and negotiated with the team, given a specified investment.
They must be documented to drive technological choices, implementations, and operations.

* Quantify success by setting targets on indicators for individual components, system flows, and the system as a whole. Do those targets make user flows more reliable?
* Understand platform commitments. Consider the limits, quotas, regions, and capacity constraints for services
* Determine dependencies and their effect on resiliency.

### Design for resilience

Expect that component malfunctions, platform outages, performance degradations, limited resource availability, and other faults will occur.
Build resiliency in the system so that it's fault-tolerant and can degrade gracefully.

* Distinguish components that are on the critical path from those that can function in a degraded state.
* Identify potential failure points in the system, especially for the critical components, and determine the effect on user flows.
* Build self-preservation capabilities by using design patterns correctly and modularizing the design to isolate faults.
* Add the capability to scale out the critical components (application and infrastructure) by considering the capacity constraints of services in the supported regions.
* Build redundancy in layers and resiliency on various application tiers.
* Overprovision to immediately mitigate individual failure of redundant instances and to buffer against runaway resource consumption.

### Design for recovery

* Have structured, tested, and documented recovery plans that are aligned with the negotiated recovery targets. Plans must cover all components in addition to the system as a whole.
* Ensure that you can repair data of all stateful components within your recovery targets.
* Implement automated self-healing capabilities in the design.
* Replace stateless components with immutable ephemeral units.

### Design for operations

* Build observable systems that can correlate telemetry.
* Predict potential malfunctions and anomalous behavior. Make active reliability failures visible by using prioritized and actionable alerts.
* Simulate failures and run tests in production and pre-production environments.
* Build components with automation in mind, and automate as much as you can.
* Factor in routine operations and their impact on the stability of the system.
* Continuously learn from incidents in production.

### Keep it simple

* Add components to your architecture only if they help you achieve target business values. Keep the critical path lean.
* Establish standards in code implementation, deployment, and processes, and document them. Identify opportunities to enforce those standards by using automated validations.
* Evaluate whether theoretical approaches translate to pragmatic design that applies to your use cases.
* Develop just enough code.
* Take advantage of platform-provided features and prebuilt assets that can help you effectively meet business targets.

## Checklist

<https://learn.microsoft.com/en-us/azure/well-architected/reliability/checklist>

checklist recommendation codes (RE:01 ot RE:10)

## Tradeoffs

<https://learn.microsoft.com/en-us/azure/well-architected/reliability/tradeoffs>

### Security tradeoffs

* Increased workload surface area
* Security control bypass
* Old software versions

### Cost optimaization tradeoffs

* Increased implementation redundancy or waste
* Increased investment in operations that aren't aligned with functional requirements

### Operational excellence tradeoffs

* Increased operational complexity
* Increased effort to generate team knowledge and awareness

### Performance efficiency tradeoffs

* Increased latency
*Increased over-provisioning

## Design Pattersn

<https://learn.microsoft.com/en-us/azure/well-architected/reliability/design-patterns>

Design patterns that support the Reliability pillar prioritize workload availability, self-preservation, recovery, data and processing integrity, and containment of malfunctions.

* Ambassador
* Backends for Frontends
* Bulkheads
* Cache-Aside
* Circuit breaker
* Claim Check
* Compensating Transaction
* Competing Consumers
* Event Sourcing
* Federated Identity
* Gateway aggregation
* Gateway Offloading
* Gateway Routing
* Geode
* Health Endpoint Monitoring
* Index Table
* Leader Election
* Pipes and filters
* Priority queue
* Publisher/Subscriber
* Queue-based load levelling
* Rate limiting
* Retry
* Saga distributed transactions
* Scheduler agent supervisor
* Sequencial Convoy
* Sharding
* Strangler Fig
* Throttling
