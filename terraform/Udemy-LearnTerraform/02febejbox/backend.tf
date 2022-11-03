terraform {
    backend "azurerm" {
        resource_group_name = "ssub-terra-rg"
        storage_account_name = "ssubsa01"
        container_name = "ssubstate"
        key = "backend-test.tfstate"
    }
}