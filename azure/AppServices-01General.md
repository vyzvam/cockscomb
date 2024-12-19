# App Services

## Best Practices

### Monitoring

Configure Alerts:
Configure alerts for App Service and App Service plan level. The recommended alerts which must be configured are as follows:

* Average Response Time: The average time spent for the app to service requests in ms.
* Average memory working set: The average amount of memory in MiBs used by the app.
* HTTP Server Errors: Count of requests resulting in an HTTP status code >=400 but <500
* CPU Percentage: The average CPU used across all instances of the plan. It’s recommended to configure this alert at 80 percent.
* Memory Percentage: The average memory used in all instances of the plan. It’s recommended to configure this alert at 80 percent.

## Availability

Configure Scale Out in App Service plan

based on 80% threshold of both cpu and memory scale up or down.
<https://docs.microsoft.com/en-us/azure/monitoring-and-diagnostics/insights-how-to-scale>

## Security

### Enforce HTTPS

Redirect all HTTP requests to the HTTPS port for your web app. select Custom domains. Then, in HTTPS Only, select On.

### Configure SSL Certificate

Apply SSL certificate when using custom domain to your web app to make the site secure.

When a web application is created using Azure App Service, it is assigned to a subdomain of azurewebsites.net. For example, if the app name is Demo, the URL is demo.azurewebsites.net. By default, Azure enables HTTPS with a wildcard certificate assigned to the *.azurewebsites.net domain.

* Map Custom Domain: <https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-domain>
* Bind SSL Certificate: <https://docs.microsoft.com/en-us/azure/app-service/app-service-web-tutorial-custom-ssl>

### IP Restrictions

Define a list of IP addresses that are allowed to the app. The allow list can include individual IP addresses or a range of IP addresses defined by a subnet mask.
When a request to the app is generated from a client, the IP address is evaluated against the allow list. If the IP address is not on the list, the app replies with an HTTP 403 status code.

## Backup

Configure a continuous deployment workflow for your Azure Web Apps. App Service integration with BitBucket, GitHub, and Visual Studio Team Services (VSTS) enable a continuous deployment workflow where Azure pulls in the most recent updates from your project published to one of these services.
By using tools such as GitHub and VSTS you can use features such as collaboration, tracking commits, rollback, backup, etc.

* <https://docs.microsoft.com/en-us/azure/app-service/app-service-continuous-deployment>
