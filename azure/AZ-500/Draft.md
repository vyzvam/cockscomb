# az500 Course

<https://feedback.iverson.com.my/ifs/eattendance.php>
class id 31013
student id 143847

subscription id a2a0b65e-73b0-499b-a4e4-f085fd97eb69

password hash synchronization (phs)
pass-through authentication (pta)

Azure AD identity protection

* MFA authentication registration policy
* User risk remediation policy
* Sign-in risk remediation policy

Azure identity protection risk events

Privilege Identity Management (PIM)

Enterprise governance

joseph Hana0371

AdatumLab500ssub

<aaduser1@adatumlab500ssub.onmicrosoft.com>  Balo8792 , Balo8792a    app password name: az500user01, password: xbkcwpksqsdxzsgr
<aaduser2@adatumlab500ssub.onmicrosoft.com>  Dada6813 , Dada6813aa
<aaduser3@adatumlab500ssub.onmicrosoft.com>  Xoju8353 , Xoju8353aa

Creating a user, group in bash and assign user

 DOMAINNAME=$(az ad signed-in-user show --query 'userPrincipalName' | cut -d '@' -f 2 | sed 's/\"//')
 az ad user create --display-name "Dylan Williams" --password "Pa55w.rd1234" --user-principal-name Dylan@$DOMAINNAME
 az ad user list --output table
 az ad group create --display-name "Service Desk" --mail-nickname "ServiceDesk"
 az ad group list -o table
 USER=$(az ad user list --filter "displayname eq 'Dylan Williams'")
 OBJECTID=$(echo $USER | jq '.[].id' | tr -d '"')
 az ad group member add --group "Service Desk" --member-id $OBJECTID
 az ad group member list --group "Service Desk"

checking DNS available
Test-AzDnsAvailability -DomainNameLabel ssub-az500 -Location 'East US'

ssubaz500.onmicrosoft.com

<syncadmin@ssubaz500.onmicrosoft.com>
syncadmin Pa55w.rd1234

10.0.1.4

az5001740427022

20.85.184.86

10.240.0.115

nginxexternal-956bf65cb-srczs

kubectl exec -it nginxexternal-956bf65cb-srczs -- /bin/bash

 curl <http://10.240.0.115>

e00ba355-e26d-4f1e-a0c2-f5fabd8e10b2

tQp8Q~84Jbm4t5cksuVt6Epp8Wvi7LxR32h6CaL.
f26b7ba0-6875-4191-893c-b1cf53fae95d

$applicationId = 'e00ba355-e26d-4f1e-a0c2-f5fabd8e10b2'

Server=tcp:sqlserverrxrijyuqekyts.database.windows.net,1433;Initial Catalog=medical;Persist Security Info=False;User ID=Student;Password=Pa55w.rd1234;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

vm public ip 20.25.126.78

sql server name: sqlserverrxrijyuqekyts.database.windows.net

## create a new resource group & verify the resource group was created

az group create --name AZ500LAB09 --location eastus
az group list --query "[?name=='AZ500LAB09']" -o table

### create a new Azure Container Registry (ACR) instance (The name of the ACR must be globally unique) & confirm that the new ACR was created

az acr create --resource-group AZ500LAB09 --name az500$RANDOM$RANDOM --sku Basic
az acr list --resource-group AZ500LAB09

### create a Dockerfile to create an Nginx-based image

echo FROM nginx > Dockerfile

### build an image from the Dockerfile and push the image to the new ACR

ACRNAME=$(az acr list --resource-group AZ500LAB09 --query '[].{Name:name}' --output tsv)
az acr build --image sample/nginx:v1 --registry $ACRNAME --file Dockerfile .

Create AKS cluster with Network configuration as Azure CNI

### connect to the Kubernetes cluster & list nodes of the Kubenetes cluster

az aks get-credentials --resource-group AZ500LAB09 --name MyKubernetesCluster
kubectl get nodes

### configure the AKS cluster to use the Azure Container Registry instance you created earlier in this lab

ACRNAME=$(az acr list --resource-group AZ500LAB09 --query '[].{Name:name}' --output tsv)
az aks update -n MyKubernetesCluster -g AZ500LAB09 --attach-acr $ACRNAME

### grant the AKS cluster the Contributor role to its virtual network

RG_AKS=AZ500LAB09
AKS_VNET_NAME=AZ500LAB09-vnet
AKS_CLUSTER_NAME=MyKubernetesCluster
AKS_VNET_ID=$(az network vnet show --name $AKS_VNET_NAME --resource-group $RG_AKS --query id -o tsv)
AKS_MANAGED_ID=$(az aks show --name $AKS_CLUSTER_NAME --resource-group $RG_AKS --query identity.principalId -o tsv)

az role assignment create --assignee $AKS_MANAGED_ID --role "Contributor" --scope $AKS_VNET_ID

## az-500 notes (Udemy)

Zero trust model
Never assume trust, instead verify trust continuously for users and devices

## User & Group management

verify user -> validate device -> limit access & privilege

users can be in cloud identity, directory synced identity, guest users

groups can be security groups, office 365

members can be added to groups directly or dynamically

user management -
