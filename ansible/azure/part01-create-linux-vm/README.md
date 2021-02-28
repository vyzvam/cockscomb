
# Demo: Enable Kubectl, Ansible and terraform in Linux VM (Ubuntu18.04) in Azure

## 0. Outline
* Prerequisites
* Azure Cloud Shell (Skip this)
* VM creation yml
* Execution
* Accessing from a local machine
* Setup Ansible
* Test run resource group creation


## 1. Prerequisites
1. Azure account
2. Service principal (with read access to subscription)
3. A Ubuntu VM in azure


## 2. Credentials related
create your ssh keys. use the default path/file in the first prompt. supply a password when prompted.
```c#
ssh-keygen -t rsa -C "email@example.com"
```

Store your azure credentials related details in the `~/.azure/credentials` path with the below format
```c#
[default]
subscription_id=XXXXXXXXXXXXXXXXXXXXXXXX
client_id=YYYYYYYYYYYYYYYYYYYYYYYY
secret=!@#@W%^YREYHTGSGFEWRT#$
tenant=ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
```
### Accesing from local machine
Copy your public key from the ~/.ssh/id_rsa.pub.
access the `~/.ssh/authorized_keys` in the vm. Add the public key in a new line.


## 3. Instal Azure CLI
```c#
//install azure cli with the steps below
sudo apt-get update

sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

// MS signing key
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

// Add the repo
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list

//install
sudo apt-get update
sudo apt-get install azure-cli
```

## 4. Setup Ansible

```c#
sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev python-pip

sudo pip install ansible[azure]
```

## 5. Setup Kubectl

```c#
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

## 6. Sample deployment
Create a resource group in azure using ansible.

First, create the yaml file `touch rg-create.yml`.
Then add the following text in it.
```c#
---
- hosts: localhost
  vars:
      resource_group: ssubansibletest
      location: eastus
  tasks:
    - name: Create a resource group
      azurerm_resource_group:
          name: {{ resource_group }}
          location: {{ location }}
```

Run `ansible-playbook rg-create.yml`. This will start the provisioning

once the execution is complete, verify if th resource group exists
```c#
az group show -n ssubansibletest
```


## References
* [Azure AD integration](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli).
* [Azure AD RBAC](https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac).
* [RBAC configuration with Ansible](https://docs.microsoft.com/en-us/azure/developer/ansible/aks-configure-rbac#configure-azure-ad-for-aks-authentication).
* [Install on linux](https://docs.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm#file-credentials).
* [azure cli authenticatin](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest).
* [Sample: AKS AAD Integration](https://github.com/Azure-Samples/azure-cli-samples/blob/master/aks/azure-ad-integration/azure-ad-integration.sh).
* [Authx2 Best practices for AKS](https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-identity)



