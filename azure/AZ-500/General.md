# AZ500 Intro

## Purpose

* securing cloud infra
* protecting cloud assets
* safeguarding investments

## Importance of security

* Threats from internet
* Security breaches
* Loss of revenue
* Compliance requirement
* Information protection

## Azure Blueprints

Enable cloud architects central information tech group to define a set of repeatable set of azure resources
that implements and adhere to an organization standards, patterns & requirements.

For environment setup, often consists of resource groups, policies, role assignments & resource manager template deployments.

### Howto

Goto->Blueprints->Create a blueprint or Blueprint definitions

There are predefine blueprints that can be used, e.g. HIPAA

Specify name & description
specify Definition location: e.g. the subscription

Artifact: choose one 

* policy assignment
* role assignment
* Azure resource manager template
* resource group

Publish the blueprint: name the blueprint

Assign blue print: select the published blueprint

Assign lock & managed identity

Create a VM

Goto->TheVM->IAM->The blueprint definitions are applied to the provisioning

Removing a blueprint does not remove what was applied on existing resources.



