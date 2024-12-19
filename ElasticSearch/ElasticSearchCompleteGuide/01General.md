# Elastic Search Complete guide - General

Reference:
<https://sitecore.udemy.com/course/elasticsearch-complete-guide/>
<https://github.com/codingexplained/complete-guide-to-elasticsearch>

Other learning reference:
<https://github.com/mr1716/Elastic-Certified-Engineer-Exam-8.1>

An open source analytics & full text search engine
Data is stored as document which is a JSON object

## Elastic Stack

### Kibana

Analytical and visualization platform.

### Logstash

Used to inject logs from application to elastic search.
It is also a data processing pipeline.
It contains three parts, inputs, filters & outputs.

Input plugins are available to retreive data from the source.
Filter with filter plugin used to process the incoming data.
Data enrichmient and transformation is done at this state.
Output plugin is to configure the target of the output

### X-Pack

Security feature, it adds authentication and authorization for both Kibana and Elasticsearch.
Can integrate with LDAP, Active Directory, etc.
Monitoring of Elastic stack components.
Reporting, allows kibana visualization and dashboards.

### Machine learning

Abnormality detection & forcasting

### Graph

Identify relationship between data , using relevance capabilities of elasticsearch

### SQL

Ability to query data using SQL queries

## Beats

Data shippers, light weight agents


