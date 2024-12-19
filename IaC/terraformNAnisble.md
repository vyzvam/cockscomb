# Terraform & Ansible related

## Working with terraform

choco install terraform (installs terraform)

create a tf file and add sample content (create a resource group)

terraform init

terraform plan

terraform plan -out=up.plan
terraform plan --destroy -out=down.plan

terraform apply up.plan
terraform apply down.plan

vim terraform.tfstate (view state file)

terraform state list
terraform show

terraform state show <name>

terraform graph (visualization content)
terraform graph (visualization content)

registry.terraform.io

integrate with AzureAD

test work with windows container, AKS & Terraform and apply security access

SP read access to an aks cluster

## Ansible related

### References
<https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli>
<https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac>
<https://docs.microsoft.com/en-us/azure/developer/ansible/aks-configure-rbac#configure-azure-ad-for-aks-authentication>
<https://docs.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm#file-credentials>
<https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest>
<https://github.com/Azure-Samples/azure-cli-samples/blob/master/aks/azure-ad-integration/azure-ad-integration.sh>
