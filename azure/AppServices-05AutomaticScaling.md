# App Services, Automatic Scaling

## Reference

* <https://learn.microsoft.com/en-us/azure/app-service/manage-automatic-scaling?tabs=azure-portal>
* <https://learn.microsoft.com/en-us/azure/azure-monitor/autoscale/autoscale-get-started>

## Requirements, limitations & support details

* Currently available for Premium V2 (P1V2, P2V2, P3V2) and Premium V3 (P1V3, P2V3, P3V3) pricing tiers.
* Supported for all app types: Windows, Linux, and Windows container.
* Automatic scaling is not supported for deployment slot traffic.
* **Always On** must be disabled
* pre-warmed instance count can only be updated via CLI
* Function apps are not supported, App Service plan should only have app services. Insteand **Function App Premium Plan** is supported

## General

Scale out option that automatically handles scaling decisions for web apps and App Service Plans.
It's different from the pre-existing Azure autoscale, which lets you define scaling rules based on schedules and resources.
Can adjust scaling settings to improve app's performance and avoid cold start issues.

The platform prewarms instances to act as a buffer when scaling out, ensuring smooth performance transitions.

Use Application Insights Live Metrics to check your current instance count, and performanceCounters to see the instance count history.

**No rule-based or scheduling-based scaling**. the platform manages the scale out and in based on HTTP traffic.

There is a minimum of 1 always ready instance and there is 1 prewarmed instances by default.

There is max limit of scale per-app.

## Configurations

### Max burst & always ready instances

In summary, these are min and max settings for number of instances

### Enforce scale out limit & Maximum scale out limit

This is to limit the number of instances to scale

## Costing

You're charged per second for every instance, including prewarmed instances.

## Areas to investigate / POC

* Setup environment with autoscale, simulate and observe the metrics
* CD currently uses 2 to 8 instances (by SKU) by default. identify how scaling can help
* Impact on current monitoring and alerts
* Impact when **App Service Health Check** is enabled

## POC

Make sure Microsoft.Monitor service is registered in the subscription
