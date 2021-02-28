
# Demo: AKS with Prometheus

## 1. Azure Container Registry (ACR) & Docker Image

### 1.1 Creating a registry

```c#
//Create a resource group
az group create --name ssubdock --location southeastasia

//Create an ACR
az acr create --name ssubacr --sku Basic --resource-group ssubdock

//Login to ACR
az acr login --name ssubacr
```

### 1.2 Pushing image to registry
```c#
//get acr server address
$address = az acr list -g ssubdock --query '[].{acrLoginServer:loginServer}' -o tsv

//verify the result
$address

//check for local images
docker images

//tag the image, make sure the tag is applied
docker tag vyzvam/nodejs $address/startrek:v1

//push and verify the image
docker push $address/startrek:v1
az acr repository list -n ssubacr
```

### 1.3 Verify the image by running it locally
```c#
//remove the local image
docker rmi $address/startrek:v1

//pull image from our ACR
docker pull $address/startrek:v1

//run a container from the image
docker run -rm --name startrek -p 8080:3000 $address/startrek:v1

//verify that the container is running
curl -Uri http://localhost:8080
```

### 1.4 Cleanup
```c#
//Cleanup
docker stop startrek
docker rmi $address/startrek:v1
```

## 2. Creating an AKS cluster

### 2.1 AKS Credentials
```c#
//creats sp and gets the result
$sp = az ad sp create-for-rbac --skip-assignment

// Content example
{
  "appId": "b5993773-6635-4243-8f62-dbd7d75d75c6",
  "displayName": "azure-cli-2020-04-19-12-55-58",
  "name": "http://azure-cli-2020-04-19-12-55-58",
  "password": "365578e4-e631-40a9-9c9d-98154dc5d76b",
  "tenant": "91700184-c314-4dc9-bb7e-a411df456a1e"
}

//get the acr resource id
az acr show -g ssubdock- -n ssubacr --query "id" -o tsv

//create a role assignment, using the app id from the sp.txt and the resource id from the command above
az role assignment create --assignee b5993773-6635-4243-8f62-dbd7d75d75c6 --scope /subscriptions/a58f4f07-6319-4d8a-b908-1e047d2fd178/resourceGroups/ssubdock/providers/Microsoft.ContainerRegistry/registries/ssubacr --role Reader
```

### 2.2 Cluster deployment
```c#
az extension add -n aks-preview

//get the supported aks versions
az aks get-versions -l southeastasia -o table

//create cluster
az aks create -g ssubdock -n ssubfreight --node-count 1 --max-pods 31 --kubernetes-version <KubernetesVersion> --generate-ssh-keys --enable-vmss --enable-cluster-autoscaler --min-count 1 --max-count 3 --service-principal b5993773-6635-4243-8f62-dbd7d5d75c6 --client-secret 365578e4-e631-40a9-9c9d-98154dc5d76b

//get kubectl
az aks install-cli

//setting the context
az aks get-credentials -g ssubdock -n ssubfreight --admin

//verify kubectl is working
kubectl get nodes

//verify versions
kubectl version
```

### 2.3 Deploying an app.
```c#
//get the acr url
 $address = az acr list -g ssubdock --query "[].{acrLoginServier:loginServer}" --output tsv

//verify the result
$address
```

Open and observe the 'startrek.yaml.
> **ATTENTION!!** Make sure to **CHANGE** the {address} with $address's value

```c#
kubectl apply -f startrek.yml

//get / watch the load balancer service externam IP
kubectl get svc startrek -w

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

//credentials: admin/prom-operator
```
