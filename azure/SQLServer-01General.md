# Azure SQL Server

## References

* <https://learn.microsoft.com/en-us/azure/azure-sql/azure-hybrid-benefit?view=azuresql&tabs=azure-portal>

## Summary

## Azure Hybrid Benefit

Exchange existing licenses for discounted rates on Azure SQL Database and Azure SQL Managed Instance. You can save up to 30 percent or more on SQL Database and SQL Managed Instance by using your Software Assurance-enabled SQL Server licenses on Azure.

Pay only for the underlying Azure infrastructure by using existing SQL Server license for the SQL Server database engine itself (Base Compute pricing). If you do not use Azure Hybrid Benefit, you pay for both the underlying infrastructure and the SQL Server license (License-Included pricing).

For Azure SQL Database, Azure Hybrid Benefit is only available when using the provisioned compute tier of the vCore-based purchasing model.

### License footprint What does Azure Hybrid Benefit for SQL Server get you?

#### SQL Server Enterprise Edition core customers with SA

* Can pay base rate on Hyperscale, General Purpose, or Business Critical SKU
* One core on-premises = Four vCores in Hyperscale SKU1
* One core on-premises = Four vCores in General Purpose SKU
* One core on-premises = One vCore in Business Critical SKU

#### SQL Server Standard Edition core customers with SA

* Can pay base rate on Hyperscale, General Purpose, or Business Critical SKU
* One core on-premises = One vCore in Hyperscale SKU1
* One core on-premises = One vCore in General Purpose SKU
* Four cores on-premises = One vCore in Business Critical SKU

## Software Assurance (SA)

A key mechanism to stay current with the latest SQL Server versions.
Not only does it provide you with a range of benefits like license mobility and virtualization rights,
but it also makes it easier to upgrade to the latest SQL Server version like SQL Server 2022.

You have access to new versions of licensed software released during the term of your agreement to deploy at your own pace.
This means that if you’re on an older version, say SQL Server 2019, and SQL Server 2022 is released while you have active Software Assurance coverage, you’re entitled to upgrade to SQL Server 2022 at no additional licensing cost.

Please remember, however, that while Software Assurance covers the licensing cost of the upgrade, it does not automatically cover the costs associated with the actual upgrade process such as possible hardware upgrades, testing, and migration of your databases.

### SQL Server 2022 Software Assurance

A program offered by Microsoft that helps you get the most out of their software products and boost your IT productivity.

It can help you manage and deploy the software more efficiently and improve productivity.
And if you need more hardware or licenses, you can easily add them without worrying about your version.
With SA, you can combine current and future version licenses under the core licensing model without hassle.

Customers with subscription licenses through the Microsoft Customer Agreement also get some of the same benefits as SA customers,
like access to the latest versions and options for virtualization.
Just keep in mind that these subscriptions don’t come with License Mobility through SA.

Complete list of benefits in the official SQL Server 2022 licensing guide at <https://www.microsoft.com/en-us/sql-server/sql-server-2022-pricing>

Short rundown of what you can get by combining SQL Enterprise Edition with SA or subscription licenses:

* Keep your SQL Server up to date with all the latest features
* Use as many virtual machines as you want
* Use your existing licenses to move to the cloud
* Get high availability and disaster recovery at no extra cost
* Create on-premises data visualizations with Power BI Report Server

### Achieve Cost Savings

By applying your existing Windows Server, SQL Server licences, and Linux subscriptions to Azure Hybrid Benefit you can realise substantial cost saving. AWS is up to 5 times more expensive than Azure for Windows Server and SQL Server. You may also see savings estimated to up to 76% with Azure Hybrid Benefit for Linux.

### Modernise and Manage a Flexible Hybrid Environment

Utilise Azure services while staying on-prem to help modernise and manage your infrastructure and test cloud specific services with solutions. Run Azure Kubernetes Service, and Azure Stack HCI at no additional cost through Azure Arc for Windows Servers.

Build a business case in Azure Migrate with Azure Hybrid Benefit to help forecast cost savings during migration.

### Leverage adjacent Azure services and benefits

Use Azure Hybrid Benefit with adjacent Azure benefits and offers such as reservations, Azure savings plan for compute, and Extended Security Updates to maximise cost savings while optimising business applications.

#### Reservations

The cloud provides efficient ways of running technology. As a cloud provider, we focus on pricing innovation with the goal of helping you save more. This gives you more cloud for less cost, while maintaining simplicity.

Receive a discount on your Azure services by purchasing reservations. Giving us visibility into your one-year or three-year resource needs in advance allows us to be more efficient. In return, we pass these savings onto you as discounts of up to 72 percent.

#### Azure savings plan for compute

Azure Virtual Machines 2
Azure App Service 3
Azure Functions premium plan
Azure Container Instances
Azure Dedicated Host
Azure Container Apps
Azure Spring Apps Enterprise

#### Extend security updates

## SQL Server Always on

* <https://learn.microsoft.com/en-us/sql/sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server?view=sql-server-ver16>
* <https://learn.microsoft.com/en-us/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-ver16>

Highly available and resilient database environment

### Always On Failover Clustering Instances (FCIs)

It leverages Windows Server Failover Clustering (WSFC) functionality to provide local high availability through redundancy
at the server-instance level-a failover cluster instance (FCI).
An FCI is a single instance of SQL Server that is installed across Windows Server Failover Clustering (WSFC) nodes and, possibly, across multiple subnets. On the network, an FCI appears to be an instance of SQL Server running on a single computer, but the FCI provides failover from one WSFC node to another if the current node becomes unavailable.

### Always On Availability Groups (AGs)
