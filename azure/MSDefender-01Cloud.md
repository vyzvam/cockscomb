# Microsoft Defender for Cloud

* <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-cloud-introduction#defend-against-threats>
A cloud-native application protection platform (CNAPP).
Made up of security measures and practices designed to protect cloud-based applications from various cyber threats and vulnerabilities.

Defender for Cloud combines the capabilities of:

* A development security operations (DevSecOps) solution that unifies security management at the code level across multicloud and multiple-pipeline environments
* A cloud security posture management (CSPM) solution that surfaces actions that you can take to prevent breaches
* A cloud workload protection platform (CWPP) with specific protections for servers, containers, storage, databases, and other workloads

Helps security teams investigate attacks across cloud resources, devices, and identities.
Provides an overview of attacks, including suspicious and malicious events that occur in cloud environments.
Accomplishes this goal by correlating all alerts and incidents, including cloud alerts and incidents.
Gaining access to Microsoft Defender XDR (Extender / Cross-layered Detection and Response) is automatic when Defender for Cloud is enabled.

## Secure Cloud Applications

* <https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-devops-introduction>

Incorporates good security practices early during the software development process, or DevSecOps.
Protects your code management environments and your code pipelines, and get insights into your development environment security posture from a single location. Empowers security teams to manage DevOps security across multi-pipeline environments.

### Code pipeline insights

Gives the security team the ability to ability protect applications and resources from code to cloud across multi-pipeline environments, including GitHub, Azure DevOps, and GitLab. DevOps security findings, such as Infrastructure as Code (IaC) misconfigurations and exposed secrets, can then be correlated with other contextual cloud security insights to prioritize remediation in code.

*Included in Foundational CSPM (Free) and Defender CSPM.*

## Improving Security Posture

Defender for Cloud recommendations identifies the steps need to secure environments.
Includes Foundational CSPM capabilities for free. You can also enable advanced CSPM capabilities by enabling the Defender CSPM plan.

* Centralized policy management, included Foundation CSPM
* Secure Score, included Foundation CSPM
* Multi-cloud Coverage, included Foundation CSPM
* Cloud Security Posture Management, included Foundation CSPM
* Advanced Cloud Security Posture Management, enabled via Defender CSPM
* Data Security Posture Management, enabled via Defender CSPM or Defender for Storage
* Data Security Posture Management, enabled via Defender CSPM or Defender for Storage
* Attack Path Analysis, enabled via Defender CSPM
* Cloud Security Explorer, enabled via Defender CSPM
* Security Governance, enabled via Defender CSPM
* MS Entra Permission Management, enabled via Defender CSPM

## Protect Cloud Workloads

Cloud workload protections (CWP) surface workload-specific recommendations that lead you to the right security controls to protect your workloads.

* Protect Cloud Servers, Enabled in Defender Servers Plan
* Identify threats to storage resources, Enabled in Defender for Storage
* Protect Cloud Databases, Enabled in Defender: for Azure SQL Databases, for SQL Servers on machines, for Open-Source relational databases, for  Azure Cosmos DB
* Protect Containers, Enabled in Defender for Containers
* Infrastructure service insights, Defender: for App Services, for KeyVault, for Resource Manager, for DNS
* Security Alerts, Any workload protection defender plan
* Security Incidents, Any workload protection defender plan

## Roles & Permissions

* <https://learn.microsoft.com/en-us/azure/defender-for-cloud/permissions>

Uses RBAC to provide builtin roles.

In Defender for Cloud, you only see information related to a resource when you're assigned to one of Owner, Contributor or Reader roles for the subscription or for the resource group the resource is in.

Security Reader: Read-only access to Defender for Cloud. Can view recommendations, alerts, a security policy, and security states, but can't make changes.
Security Admin: Has the same access as the Security Reader and can also update the security policy, and dismiss alerts and recommendations.

## Security Recommendations

* <https://learn.microsoft.com/en-us/azure/defender-for-cloud/security-policy-concept>

Security policies consist of security standards and recommendations that help to improve your cloud security posture.

Security standards:-

* define rules
* compliance conditions for those rules
* Actions (effects) to be taken if conditions aren't met.

Defender for Cloud assesses resources and workloads against the security standards enabled in your Azure subscriptions, AWS accounts, and (GCP) projects.
Based on those assessments, security recommendations provide practical steps to help you remediate security issues.

Security standards sources:

*Microsoft cloud security benchmark (MCSB)*
The MCSB standard is applied by default when cloud accounts are onbiarded to Defender.
Secure score is based on assessment against some MCSB recommendations.

*Regulatory compliance standards*
When one or more Defender for Cloud plans are enabled, standards from a wide range of predefined regulatory compliance programs can be added.

*Custom standards*
Custom security standards in Defender for Cloud can be created, built-in and custom recommendations to those custom standards can be added as needed.

Security standards in Defender for Cloud are based on *Azure Policy initiatives* or on the Defender for Cloud native platform.
Azure standards are based on Azure Policy.
AWS and GCP standards are based on Defender for Cloud.
