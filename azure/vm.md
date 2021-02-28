# Setting Up VM

```c#
az vm create -g ssublearn -n ssubDebian --image Debian --admin-username ssub --admin-password 123!@#qweQWE 

az vm show -g ssublearn -n ssubDebian

ipAddress=$(az vm list-ip-addresses -g ssublearn -n ssubDebian --query '[].{ip:virtualMachine.network.publicIpAddresses[0].ipAddress}' --output tsv)

ssh ssub@$ipAddress

az network nsg rule create --resource-group PacktPub --nsg-name CLINSG --name allow-https --description "Allow access to port 80 for HTTP"--access Allow --protocol Tcp --direction Inbound --priority 1030 --source-address-prefix "*" --source-port-range "*"--destination-address-prefix "*" --destination-port-range "80"

```