
# Demo: AKS with ASP.Net WebApp

## 1. Azure Container Registry (ACR) & Docker Image

### 1.1 Creating a registry

```c#
//Create a resource group
az group create n ssubaksrg -l eastus

//Create an ACR
az acr create -n ssubacr --sku Basic -g ssubaksrg

```

### 1.2 Pushing image to registry
```c#
//get acr server address
$address = az acr list -g ssubdock --query '[].{acrLoginServer:loginServer}' -o tsv

//verify the result
$address
```

### 1.3 Prepare local container

```c#
//we will use a aspnet sample image from mcr.microsoft.com/dotnet/framework/samples:aspnetapp
docker pull mcr.microsoft.com/dotnet/framework/samples:aspnetapp

//test run the image locally
docker container -it --rm -p 8000:80 --name sample mcr.microsoft.com/dotnet/framework/samples:aspnetapp
curl -Uri http://localhost:8000

//tag the image, make sure the tag is applied
docker tag mcr.microsoft.com/dotnet/framework/samples:aspnetapp $address/mssamples:v1

//Login to ACR
az acr login -n ssubacr

//push and verify the image
docker push $address/startrek:v1
az acr repository list -n ssubacr
```

### 1.3 Verify the image by running it locally
```c#
//remove the local image
docker rmi $address/mssamples:v1

//pull image from our ACR
docker pull $address/startrek:v1

//run and verify a container from the image, then remove the image
docker container -it --rm -p 8000:80 --name sample mcr.microsoft.com/dotnet/framework/samples:aspnetapp

curl -Uri http://localhost:8000

docker rmi $address/mssamples:v1
```

## 2. Creating an AKS cluster

### 2.1 AKS Credentials
```c#
//creats sp and gets the result
$sp = az ad sp create-for-rbac --skip-assignment -n ssubAKSServicePrincipal

// Content example
{
  "appId": "b5993773-6635-4243-8f62-dbd7d75d75c6",
  "displayName": "ssubAKSServicePrincipal",
  "name": "http://ssubAKSServicePrincipal",
  "password": "365578e4-e631-40a9-9c9d-98154dc5d76b",
  "tenant": "91700184-c314-4dc9-bb7e-a411df456a1e"
}

//get the acr resource id
$acrId = az acr show -g ssubaksrg -n ssubacr --query "id" -o tsv

//create a role assignment, using the app id from the sp.txt and the resource id from the command above
az role assignment create --assignee b5993773-6635-4243-8f62-dbd7d75d75c6 --scope $acrId --role Reader
```

### 2.2 Cluster deployment
```c#
az extension add -n aks-preview

//get the supported aks versions
az aks get-versions -l eastus -o table

//create cluster
az aks create -g ssubaksrg -n ssubakscluster --node-count 1 --max-pods 31 --kubernetes-version <KubernetesVersion> --generate-ssh-keys --enable-vmss --enable-cluster-autoscaler --min-count 1 --max-count 3 --service-principal b5993773-6635-4243-8f62-dbd7d5d75c6 --client-secret 365578e4-e631-40a9-9c9d-98154dc5d76b


az aks create -g ssubaksrg -n ssubakscluster --node-count 1 --enable-addons monitoring --kubernetes-version 1.18.2 --generate-ssh-keys --windows-admin-password ssubSSUB123!@# --windows-admin-username ssubuser --vm-set-type VirtualMachineScaleSets --load-balancer-sku standard --network-plugin azure --service-principal 6ffb4797-afdc-4df1-ab76-8d0ea2afd1cd --client-secret 8yFX7cX.fiqJ._QGWEVvDlwdBkeM5b1Er9

az aks nodepool add -g ssubaksrg --cluster-name ssubakscluster --os-type Windows --name win --node-count 1 --node-vm-size Standard_D4_v3 --kubernetes-version 1.18.2


//get kubectl
az aks install-cli

//setting the context
az aks get-credentials -g ssubaksrg -n ssubakscluster --admin

//verify kubectl is working
kubectl get nodes

//verify versions
kubectl version
```

### 2.3 Deploying an app.
```c#
//get the acr url
 $address = az acr list -g ssubaksrg --query "[].{acrLoginServier:loginServer}" --output tsv

//verify the result
$address
```

Open and observe the 'mssamples.yaml.
> **ATTENTION!!** Make sure to **CHANGE** the {address} with $address's value

```c#
kubectl apply -f mssamples.yml

//get / watch the load balancer service externam IP
kubectl get svc mssamples -w

//verify the site is up and running
curl -Uri <EXTERNAL-IP>
```

### 3. Adding monitoring using Prometheus
We are covering metrics collection, alerting and visualization

> **NOTE**: Prometheus related artifact are used from https://github.com/Adeelku/aks-prometheus.git

```c#
//Enable monitoring addon
$ az aks enable-addons -a monitoring -n ssubfreight -g ssubdock

//have a look at the alermanager_values.yaml & prometheus_values.yaml
cd .\aks-prometheus\helm
```

### 3.1 Configure alerts & provision Prometheus
Create a slack workspace then create a channel and configure incoming webhooks.
Use the channel and the api url to **configure in the alermanager_values.yaml**.

```c#
//install prometheus

kubectl create namespace monitoring

helm upgrade --install prometheus --namespace monitoring stable/prometheus-operator --values prometheus_values.yaml --values alertmanager_values.yaml
```

### View logs in the Prometheus Operator

```c#
//Have a look at the resources deployed in the monitoring namespace
kubectl -n monitoring get all

//view logs in local machine
kubectl -n monitoring port-forward prometheus-prometheus-prometheus-oper-prometheus-0 9090

### View charts in Grafana
```c#
 $grafana=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace monitoring port-forward $grafana 3000

```
