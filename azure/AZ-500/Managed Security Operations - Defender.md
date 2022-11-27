# Managed Security Operations - Azure Defender (Formerly Security Center)

## Introduction

It is a unified infrastructure security management system
strenghtens the security posture of your data centers and provides advanced
threat protection accross hybrid workloads in cloud.

It protects non-Azure servers & Vms in the cloud or on premises, for both windows and linux servers.
Doen by installing log analytics agents.

Events collected from the agents and from azure are correlated in the security analytics engine
to provide tailored recommendation (hardening tasks) to secure workloads with security alerts.
investigate such alerts ASAP to make sure malicious attacks are not taking place.

### MS Defender plans -

Note: LAW is an addon product
<https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/defender-endpoint-plan-1-2?view=o365-worldwide#compare-microsoft-endpoint-security-plans-1>


## Defender features

### Overview

Dashboard contains Azure subscriptions, Assessed resources ,Active recommendations, Security alerts.

## Getting started

Option to upgrade

Option to Add OnPrem, AWS & GCP

## Recommendation

Will provide a list of recommendation to be applied to the relevant resource, i.e VM
It also provide remediation steps for each recommendations.

## Security alerts

observe list of security
Alert Map also provides map view of where the alert came from

Suppress rule is also available.

## Inventory

Shows the resources part of the defender shown based on
total, unhealthy, unmonitored & unregistered subscription

Resource health of a resource is accesible, it provides, resource details, recommendation, alerts & installed apps.

## Workbooks

With the integrated Azure Workbooks functionality, Microsoft Defender for Cloud makes it straightforward to build your own custom, interactive workbooks. Defender for Cloud also includes a gallery with the following workbooks ready for your customization:

* 'Secure Score Over Time' workbook - Track your subscriptions' scores and changes to recommendations for your resources
* 'System Updates' workbook - View missing system updates by resources, OS, severity, and more
* 'Vulnerability Assessment Findings' workbook - View the findings of vulnerability scans of your Azure resources
* 'Compliance Over Time' workbook - View the status of a subscription's compliance with the regulatory or industry standards you've selected
* 'Active Alerts' workbook - view active alerts by severity, type, tag, MITRE ATT&CK tactics, and location.





## Security posture

Current status of the resources, to check recommendation and apply remediateion

## Regulatory compliance

### Compliance policy

Can manage compliance policy.
Goto->Manage compliance policy-> brings you to the Environment settings
Click on one of the environment->Settings->Defender plans->Security policy
There are Industry & Regulatory standards that can be enabled.
There are also custom standards that can be created.

Initiative definition is a collection of individual polices.

Audit reports are available 

## Workload protection

Protection details of resources and services

## Firewall protection

It contains firewall policies.

## Environment Settings

Going into one of the resource will expose more configuration such as 

### Defender plans

Modify pla to include/exclude for specific services (e.g VM, App Service, Datbase , etc)

### Auto provisioning

Enabling an extension where any new or existing applicable resources by assigning security policy

### Email notificaion

Configure email notifications based on severity selectin

### Integration

Options available for Defender for cloud apps and defender for endpoint

Also with CI/CD vulnerability scanning

### Workflow automation

Can integrate to logic apps to perform automation

### Continous export


## Installing defender for on premise server

Goto->Getting Started->Add non azure servers
Or Goto->Security solutions->Non azure servers->Add

Create/select and existing workspace->Add servers

Download the relevant agent and install it in the on prem server
also take note of the workspace id and the 2 keys

Choose the option to connect to the LAW
Provide the workspace id and workspace key


## Just-in-Time

By default you can RDP in to a VM, from the overview, connect->RDP
This is possible since the Vnet inbound port rule already has a rule to allow RPD (Port 3389) from any source and destination


Goto->Workload protections->Just-in-Time VM Access

or 

Goto->TheVM->Settings->Connect->Enable JIT, which will add an inbout port rule in VNet to deny fom any source and to the VM (private IP) 

Goto->TheVM->Settings->Connect->Request access














## Howto

### Create a VM

Goto->VMs->Create

### Install log analytics workspace

Goto->Log analytics workspaces->Create
Specify->Subscription, RG, Name (MyVM), Region

Goto->Workspace data sources->VMs
Observe that MyVM is in not connected
Click->MyVM->Connect

Within Log analytics->Goto->MS Defender for cloud->Upgrade(if not already)


