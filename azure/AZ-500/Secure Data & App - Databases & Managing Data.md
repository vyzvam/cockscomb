# Secure Data & App - Databases & Managing Data

## Diagnostics logings

Can configure for Single, pool & managed instance, databases.
Can direct logs to storage account, Azure event hubs and log analytics workspace.

Difference aspects that can be reports are:-

* Basic metrics, e.g, DTU/CPUpercentage consumed, succssful/failed/blocked request by firewall
* Query duration statistics
* Information on any SQL errors on database

Configuring diagnostics logging

* Event hubs and storage accounts - Can specify retention policy
* Log analytics - retention policy depends on the select pricing tier

### Log analytics workspace

#### Configure retention

Goto->theWorkSpace->Usage and estimated costs->Data retention->Choose retention (30 to 730 days)

#### Getting log details

Goto->theWorkSpace->General->Workspace Summary->Choose Azure SQL Database

### Howto - configure diagnostic settings

Goto->TheDatabase->Monitoring->Diagnostic setting->add

* Provide a name
* select any target storage
  * Archive to a storage account
  * Stream to an event hub
  * Send to log analytics
* Log (Choose log types to store) Each has it's own retention in days
  * SQL Insights
  * Automatic tuning
  * QueryStoreRuntimeStatistics
  * QueryStoreWaitStatistics
  * Errors
  * DatabaseWaitStatistics
  * Timeouts
  * Blocks
  * Deadlocks
Metric
  * Basic
  * InstanceAndAppAdvanced
  * WorkloadManagement

## The auditing feature

* Can enable auditing at the database or server level, if sever level all databases in the server is affected.
* Can be used for regulatory compliance for underlying databases.
* Understand database activities and gain insights on any issues or anomalies.
* Retain audit trail of selected events.
* Define categories for databases actions that need to be audited.
* Use pre-configured reports to report on the database activity.
* Analyse report that can be used to detect any suspicious events or unusual activities.

### Howto - enable and view auditing

Goto->TheDatabase->Security->Auditing

* Turn on "Auditing"
* Choose destination (Storage account, event hub, log analytics)

Goto->View Audit logs->View dashboard->View the audit information

## Advanced data security feature

### Data discovery and classification

To discover, classify and protect sensitive data in databases. Track access to sensitive data.
Can review the provided recommendation and apply the recommendation.

The classificatin contains 2 metadata atrributes:-
* Labels - To define the sensitivitb level of the data stored in the column
* Information types - Provide additional granularity of the data type stored in the column.

### Vulnerability assessment

To discover track and remediate potential database vunerabilites.

* Ability to meet compliance standards
* Provide data privacy standards.
* Ability to track database changes
* Vulnerability scans are based on a set of rules that follow industry best practices.

### Advanced threat protection

Detect anomalous activities that can be used to exploit the database.

Types of alerts that can be generated using this tools are.

* Vulnerability to SQL injection - trigger whenever an app issues a faulty sql statement.
* Possible sql injection - when a malicious user trying to inject malicious sql statements.
* Access from unusual locations - When user has been detected accessing the sql server from an unusual geographical location.

### Howto

Goto-TheDatabase->Security->Advanced data security->Enable advanced data security on the server (15USD/Server/Month)

### Data discovery and classification

Goto->Data discovery and classification->
Classfications recommendations are made available
You can select the table/column->Accept or dismiss recommendation
You may also add your own classification
You may also configure the information type
You may also configure the sensitivity labels based on information type

### Vulnerability Assessment

Perform a scan
It provides recommendation with risk factor
