# Setup Az Devops Security Groups for these permissions

## Discover permissions for

* Git Read
* Git Create branch
* Git Pull request
* Git Approve pull request
* Pipeline Run
* Pipeline Stop
* Pipeline Modify
* Pipeline Edit

## Security Group related

```powershell
az devops security group create --name 'Developers' --description 'Developers' --org <https://dev.azure.com/ssub> --scope organization

az devops security group list --org <https://dev.azure.com/ssub> --scope organization

az devops security group list --org <https://dev.azure.com/ssub> --scope organization --query "graphGroups[?displayName == 'Developers'].[displayName,descriptor]"

descriptor=$(az devops security group list --org <https://dev.azure.com/ssub> --scope organization --query "graphGroups[?displayName == 'Developers'].[descriptor]" -o tsv)

az devops security group show --id vssgp.Uy0xLTktMTU1MTM3NDI0NS0zNjU3NzA5OTA2LTU3MDQwMzEzOS0zMTQzNTYzMTcyLTI5NzcwNzYzMDQtMS0xOTAxMTUyMzQ4LTI1MTQxOTA5MTgtMjI1OTUxNjMxNC0yNzc4NTY2NzMy --org <https://dev.azure.com/ssub>
```

## Permissions & Namespace

```powershell
#get namespace related details
az devops security permission namespace list --org <https://dev.azure.com/ssub>
az devops security permission namespace list --org <https://dev.azure.com/ssub> --query "[].[name, displayName, namespaceId]"

#get namespace id for Git
az devops security permission namespace list --org <https://dev.azure.com/ssub> --query "[?name == 'Git Repositories'].[name,namespaceId]"
gitNamespaceId=$(az devops security permission namespace list --org <https://dev.azure.com/ssub> --query "[?name == 'Git Repositories'].[namespaceId]" -o tsv)

#get namespace id for Build
az devops security permission namespace list --org <https://dev.azure.com/ssub> --query "[?name == 'Build'].[name,namespaceId]"
buildNamespaceId=$(az devops security permission namespace list --org <https://dev.azure.com/ssub> --query "[?name == 'Build'].[namespaceId]" -o tsv)

Repo permission list namespace-id of "Git Repositories"
2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87

az devops security permission namespace show --namespace-id 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 --org <https://dev.azure.com/ssub>

az devops security permission list --id 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 --subject vssgp.Uy0xLTktMTU1MTM3NDI0NS0zNjU3NzA5OTA2LTU3MDQwMzEzOS0zMTQzNTYzMTcyLTI5NzcwNzYzMDQtMS0xOTAxMTUyMzQ4LTI1MTQxOTA5MTgtMjI1OTUxNjMxNC0yNzc4NTY2NzMy --org <https://dev.azure.com/ssub>

az devops security permission show --id 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 --subject vssgp.Uy0xLTktMTU1MTM3NDI0NS0zNjU3NzA5OTA2LTU3MDQwMzEzOS0zMTQzNTYzMTcyLTI5NzcwNzYzMDQtMS0xOTAxMTUyMzQ4LTI1MTQxOTA5MTgtMjI1OTUxNjMxNC0yNzc4NTY2NzMy --token repoV2 --org <https://dev.azure.com/ssub>

az devops security permission update --id 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87 --subject vssgp.Uy0xLTktMTU1MTM3NDI0NS0zNjU3NzA5OTA2LTU3MDQwMzEzOS0zMTQzNTYzMTcyLTI5NzcwNzYzMDQtMS0xOTAxMTUyMzQ4LTI1MTQxOTA5MTgtMjI1OTUxNjMxNC0yNzc4NTY2NzMy --token repoV2 --org <https://dev.azure.com/ssub> --allowbit 1

#Get Developer permission list for Git
az devops security permission list --id $gitNamespaceId --subject $descriptor --org <https://dev.azure.com/ssub>

#get Developer permission list for Build
az devops security permission list --id $gitNamespaceId --subject $descriptor --org <https://dev.azure.com/ssub>

az devops security permission show --id $gitNamespaceId --subject $descriptor --token repoV2 --org <https://dev.azure.com/ssub>
az devops security permission show --id $buildNamespaceId --subject $descriptor --token 4ef99ea6-e4d9-43a9-a7a0-d372447586fe --org <https://dev.azure.com/ssub>
```

## Permission bits

//Git Read:2, Create Branch:16, Contribute to pull requests:32768
//Build View:1, queue builds, 128, Stop build pipelines:512, View build pipelines:1024, edit build pipeline:2048

## az command workflow

### Set variables

```c#
$org = <https://dev.azure.com/ssub>
$project = Demos
$group = Developers
```

### Security groups

```powershell
#create security groups
az devops security group create --name $group --description $group --org $org --scope project --project $project

#Get descriptor of Developer
az devops security group list --org $org --scope project --project $project --query "graphGroups[?displayName == 'Developer'].[descriptor]" -o tsv

$developerDescriptor=$(az devops security group list --org $org --scope project --project $project --query "graphGroups[?displayName == 'Developer'].[descriptor]" -o tsv)
```

### Namespace & token

```powershell
#Get project namespace id
az devops security permission namespace list --org $org --query "[?name == 'Project'].[namespaceId]" -o tsv

$projectNamespaceId=$(az devops security permission namespace list --org $org --query "[?name == 'Project'].[namespaceId]" -o tsv)

#Get project token for developer
$projectToken=$(az devops security permission list --id $projectNamespaceId --subject $developerDescriptor --org $org --query "[0].[token]" -o tsv)

#show Developer permissions for project
az devops security permission show --id $projectNamespaceId --subject $developerDescriptor --token $projectToken --org $org
```

### Git repo related permissions

```powershell
#get namespace id for Git
gitNamespaceId=$(az devops security permission namespace list --org $org --query "[?name == 'Git Repositories'].[namespaceId]" -o tsv)

#get namespace id for Build
buildNamespaceId=$(az devops security permission namespace list --org $org --query "[?name == 'Build'].[namespaceId]" -o tsv)

#get token for git permissions
az devops security permission list --id $gitNamespaceId --subject $descriptorSystemAdmin --org $org --query "[].[token]" -o tsv

#get token for build permissions

#Get Developer permission list for Git (token will be available here)
az devops security permission list --id $gitNamespaceId --subject $descriptor --org $org

#get Developer permission list for Build (token will be available here)
az devops security permission list --id $gitNamespaceId --subject $descriptor --org $org

#show Developer permission list for Git
az devops security permission show --id $gitNamespaceId --subject $descriptor --token repoV2 --org $org

#show Developer permission list for Build
```