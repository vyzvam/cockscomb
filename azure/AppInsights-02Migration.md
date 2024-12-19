# Application Insights Migration

## Migrating and moving App Insights Classic to App Insights workspace based

### Usecase #1: move app insights from Central India to South India

```c#
$primary = @{
 ResourceGroup = "ssubcaapj-testai"
 Location = "Central India"
}

$secondary = @{
 ResourceGroup = "secondary-ssubcaapj-testai"
 Location = "South India"
}

$LogAnalyticsWorkspaceName = "ssubcaapj-testai-oms"
$appInsightsName = "ssubcaapj-testai-ai"

New-AzResourceGroup -Name $secondary.ResourceGroup -Location $secondary.Location
New-AzResourceGroup -Name $primary.ResourceGroup -Location $primary.Location

New-AzApplicationInsights -ResourceGroupName $secondary.ResourceGroup -Name $appInsightsName -location $primary.Location
New-AzApplicationInsights -ResourceGroupName $secondary.ResourceGroup -Name $appInsightsName -location $secondary.Location

New-AzOperationalInsightsWorkspace -ResourceGroupName $secondary.ResourceGroup -Name $LogAnalyticsWorkspaceName -Location $secondary.Location -Sku "PerGB2018"

$appInsights = Get-AzApplicationInsights -ResourceGroupName $secondary.ResourceGroup -Name $appInsightsName

Get-AzApplicationInsights -ResourceGroupName $secondary.ResourceGroup -Name $appInsightsName | Format-Table -Property Name, IngestionMode, WorkspaceResourceId, @{label='Type';expression={if ($_.ingestionMode -eq 'LogAnalytics') {'Workspace-based'} elseif ($_.IngestionMode -eq 'ApplicatonInsights') {'Classic'}}}

Get-AzResourceGroup -Name $primary.ResourceGroup | Remove-AzResourceGroup -Force
Get-AzResourceGroup -Name $secondary.ResourceGroup | Remove-AzResourceGroup -Force
```
