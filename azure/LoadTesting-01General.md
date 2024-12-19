# Azure Load Testing

## References

* <https://www.youtube.com/watch?v=kfIS7uO1CPE&ab_channel=MattAllford>
* <https://learn.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal>
* <https://learn.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test?tabs=portal>
* <https://learn.microsoft.com/en-us/azure/load-testing/how-to-create-and-run-load-test-with-jmeter-script?tabs=portal>
* <https://github.com/Azure-Samples/azure-load-testing-samples/tree/main/jmeter-basic-endpoint>

## Summary

Azure Load Test uses JMeter to automate load testing and shows
client side (any resource) and server side (azure resources only) metrics.
It is to help understand granular performance of the solution.

Azure provides the test engines and it is managed automatically. We can specify the number of users (250 is the max recommended by MS).
We can also specify the load, parameters & criteria of the test.

the load test produces the client metrics and shows it in the dashboard. It also adds server side metrics, when configured, captured from
azure monitor.

We can also integrate azure load test with GitHub Actions and Azure DevOps.

## Cost

* $10.00 / month / azure load test resource
* First 150 users with test duration of 20 minutes per test is free
* First 50 users with test duration of 60 minutes per test is free
* First 50 users with test duration of 20 minutes with 3 tests are free

* 1 user with 1 hour test is $0.15

## Azure Load Test Resource

You can provision a Load test resource via portal / CLI / PS

```c#
//cli
az load create --name $resourceName --resource-group $resourceGroup --location $location

//ps
New-AzLoad -Name $resourceName -ResourceGroupName $resourceGroup -Location $location

```

A load test resource comes with the Load Test reader, Load Test Contributor & Load Test Owner by default

## Creating a test

Go to the load test resource click on 'Tests' on the left blade. Click Create Test.

### Basics

Specify test name, description & toggle run after creation.

### Test Plan

Upload a JMeter script, use sample from <https://raw.githubusercontent.com/Azure-Samples/azure-load-testing-samples/main/jmeter-basic-endpoint/sample.jmx>

Configure the script, e.g

ThreadGroup.num_threads = 5, number of users
ThreadGroup.ramp_time = 10, each user ramp up every 10 seconds
ThreadGroup.duration = 120, test duration in seconds

HTTPSampler.domain, the url of the site

### Parameters

Environment Variables are non sensitive values that can be configured to be changed prior to tests

Secrets are credentials or token references, i.e KeyVault to get sensitive data

### Load

Specify number of instance
Specify either private or public network

## Test Criteria

Specifiy test failure criteria

## Monitoring

Configure serverside metrics
