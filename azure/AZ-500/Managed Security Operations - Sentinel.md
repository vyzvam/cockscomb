# Managed Security Operations - Azure Sentinel

## Introduction

A cloud native SIEM (Security Infromation and event management)

## Permission & Roles (RBAC)

Az Sentinal roles are
Azure Sentinal reader
Azure Sentinal responder
Azure Sentinal contributor

Log analytics role
Log analytics contributor
Log analytics reader

## Features

Integrattions

* Oprem server
* Azure + MS 365 (Security alerts, activity data)
* Collecters (CEF, Syslog, Windows, Linux)
* TAXII + MS Graph (Threat indicators)
* APis (Custom logs)

## Howto

Goto->Azure Sentinel->Create
Specify a Log analytics workspace
Then add Azure sentinel to the workspace

Goto->Collect data->

### Choose connector(s)

Then start creating rules
Under the connector that is added/connected
Create a new rule from template
Provide general details
Add rule logic, provide entity mapping, query scheduling,
alert threshold
event grouping

### Incident settings

### Automated response

to take some actions against alerts

select a playbook
