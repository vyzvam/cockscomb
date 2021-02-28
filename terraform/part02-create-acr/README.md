
# Demo: Provision Azure Container Registry with terraform


## 1. Prerequisites
* Terraform 0.12.28
* AKS
* Az CLI


## 1. Setting up

### 1.1 Installing Terraform

```c#
//Install, using chocolatey
choco install terraform

//make sure terraform is installed (should appear in the list)
choco list --local-only

//verify version
terraform version
```

## 2. Create and prepare the terraform file (main.tf)
the sample file already available, observe the `main.tf` file

```c#
//Intialize the terraform diractory, which will also update relevant plugins / providers, specified in the tf file.
terraform init
```

## 3. Deploy the resource group
```c#
//check the terraform plan before applying the changes
terraform plan

//optionally, create a plan file for specific workflow
terraform plan -out up.pln

//make the execution, this will create the resource group in azure
terraform apply up.pln

```
