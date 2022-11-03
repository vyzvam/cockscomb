# Creating server and client app in AAD


## Creating server app

appName="SSUBAKSApp"

serverAppId=$(az ad app create --display-name "${appName}Server" --identifier-uris "https://${appName}Server" --query "appId" -o tsv)

az ad app update --id $serverAppId --set groupMembershipClaims=All


az ad sp create --id $serverAppId

serverAppSecret=$(az ad sp credential reset --name $serverAppId --credential-description "AKSPassword" --query "password" -o tsv)


az ad app permission add --id  $serverAppId --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope 06da0dbc-49e2-44d2-8312-53f166ab848a=Scope 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role


az ad app permission grant --id $serverAppId --api 00000003-0000-0000-c000-000000000000


// if cli fails , do it via portal in the API permission section)
az ad app permission admin-consent --id  $serverAppId


## create client app

clientAppId=$(az ad app create --display-name "${appName}Client" --native-app --reply-urls "https://${appName}Client" --query "appId" -o tsv)

az ad sp create --id $clientAppId



## authenticate both

oAuthPermissionId=$(az ad app show --id $serverAppId --query "oauth2Permissions[0].id" -o tsv)

az ad app permission add --id $clientAppId --api $serverAppId --api-permissions ${oAuthPermissionId}=Scope
az ad app permission grant --id $clientAppId --api $serverAppId

// IF SERVER AND CLIENT APP IS ALREADY AVAILABLE
serverAppId="89320b60-78ec-4ead-9afc-8cb0993c2337"

serverAppSecret=$(az ad sp credential reset --name $serverAppId --credential-description "AKSPassword" --query "password" -o tsv)

clientAppId="fd95eeb1-c617-422e-be3e-92acd224badf"


___
//create rg
az group create -n aksrg -l eastus


get tenant id
tenantId=$(az account show --query 'tenantId' -o tsv)

// create with ad integration
az aks create -g aksrg -n akscluster --node-count 1 --kubernetes-version 1.18.4 --generate-ssh-keys --aad-server-app-id $serverAppId --aad-server-app-secret $serverAppSecret --aad-client-app-id $clientAppId --aad-tenant-id $tenantId




az aks get-credentials --g ssubaksrg --name ssubakscluster --admin

//create role binding
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: contoso-cluster-admins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: $objectId
//


kubectl apply -f <filename>.yaml


az aks get-credentials -g ssubaksrg -n ssubakscluster --overwrite-existing

___


## aks without ad integration

sp=$(az ad sp create-for-rbac --skip-assignment --name 'aksTestClient')

az aks create -g aksrg -n akscluster-noad --node-count 1 --kubernetes-version 1.18.4 --generate-ssh-keys
az aks create -g aksrg -n akscluster-noad --node-count 1 --kubernetes-version 1.18.4 --generate-ssh-keys --service-principal $spId --client-secret $spSecret







## Usefule commands

kubectl config unset contexts

kubectl api-resources -o wide


//verify rbac
az aks show -g aksrg -n akscluster --query aadProfile



## Test with service principal

testSp=$(az ad sp create-for-rbac --skip-assignment --name testSp)

{ "appId": "4a2a774e-6bda-4378-af96-ce81f4d7ac37", "displayName": "testSp", "name": "http://testSp", "password": "y~5X~u3JHZ0LyQP-7OvCf9VU~s6yY02ut9", "tenant": "8bb124b7-de0d-4acb-86ce-b003a00159a8" }

aksId=$(az aks show -n ssubakscluster -g ssubaksrg --query 'id' -o tsv)

az role assignment create --assignee 4a2a774e-6bda-4378-af96-ce81f4d7ac37 --scope $aksId --role Reader


az login --service-principal --username 4a2a774e-6bda-4378-af96-ce81f4d7ac37 --password y~5X~u3JHZ0LyQP-7OvCf9VU~s6yY02ut9 --tenant 8bb124b7-de0d-4acb-86ce-b003a00159a8


## to resolve

The client 'live.com#vyzvam@gmail.com' with object id 'a996b5ff-949c-4c25-b6e8-ea1a0694d11e' does not have authorization to perform action 'Microsoft.ContainerService/managedClusters/listClusterUserCredential/action' over scope '/subscriptions/ff0e06ca-3adf-420b-af4f-d471c557381e/resourceGroups/ssubaksrg/providers/Microsoft.ContainerService/managedClusters/ssubakscluster' or the scope is invalid. If access was recently granted, please refresh your credentials.



## Creating a user

//generate key
openssl genrsa -out vyzvam.key 2048

//signing request
openssl req -new -key vyzvam.key -out vyzvam.csr -subj "/CN=vyzvam/O=default"

//get cert authority cert and key
eg: ca.crt & ca.key

//signing
openssl x509 -req -in vyzvam.csr -CA ca.crt -CAKey ca.key -CACreateserial -out vyzvam.crt -day 3650


//kubeconfig
//use ca.crt, vyzvam.crt & vyzvam.key


//use kubectl config view to get the details
kubectl --kubeconfig vyzvam.kubeconfig config set-cluster <cluster> --server <ip:port> --certificate-authority=ca.crt

kubectl --kubeconfig vyzvam.kubeconfig config set-credentials vyzvam --client-certificate /home/ssub/ssubaks/temp/vyzvam.crt --client-key /home/ssub/ssubaks/temp/vyzvam.key

kubectl --kubeconfig vyzvam.kubeconfig config set-context vyzvam-kube --cluster <cluster> --user vyzvam

//make sure the current-context in the kubeconfig is pointing to vyzvam-kube

//execution
kubectl --kubeconfig vyzvam.kubeconfig <command>

CLUSTER_RESOURCE_GROUP=$(az aks show -g aksrg -n akscluster --query nodeResourceGroup -o tsv)


Microsoft.ContainerService/managedClusters/listClusterUserCredential/action