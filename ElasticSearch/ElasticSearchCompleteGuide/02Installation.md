# Elastic Search Complete guide - Installation

## Elastic Search

Download from <https://www.elastic.co/downloads/elasticsearch> and extract to intended path

Run ES by executing the `bin/selasticsearch.bat` file

Capture these details from the log
password:
e.g szE*0gXro3iCOv_*VteB

HTTP CA certificate SHA-256 fingerprint:
a4a07617d5763dafff7d9dced6cca0d22911e6435c13405878a2bf8808293878

kibana enrollement token:
eyJ2ZXIiOiI4LjE0LjAiLCJhZHIiOlsiMTcyLjE4LjM2Ljg0OjkyMDAiXSwiZmdyIjoiYTRhMDc2MTdkNTc2M2RhZmZmN2Q5ZGNlZDZjY2EwZDIyOTExZTY0MzVjMTM0MDU4NzhhMmJmODgwODI5Mzg3OCIsImtleSI6IlJlNTJWSk1CWXk4WGNrdnhzWkJHOkhrb2U5c1VkUUdpN0F4TU45Wmx4MmcifQ==

###

Resetting password
`bin/elasticsearch-reset-password -u elastic -i`


## Kibana

Download from <https://www.elastic.co/es/downloads/kibana> and extract to intended path

Run Kibana by executing the `bin/kibana.bat` file

It will provide the url for us to configure kibana, open the url, supply the enrollment token.

Once done, use the password from the ES setup with the username **elastic**.


## Add more nodes

Extract the archive es file, do not copy the directory of current node!!.
Open the config/elasticsearch.yml. Change the node.name value to a meaningfull one (e.g second-node).

Create an enrollment token for the nodes to join the cluster.
run the token enrollment bat file on the initial node directory
`bin\elasticsearch-create-enrollment-token.bat --scope node`.
Copy the token and start the second node
`bin\elasticsearch --enrollment-token <token>`

note that the system indices now have replica shard since the default configuration is to `index.auto_expand_replicas`.
This will automatically create replica shards as new nodes are created.