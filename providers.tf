terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
   subscription_id = "358839b1-6b09-437c-9a68-1821e5813d04"
  tenant_id       = "5c817286-9863-4cf1-b280-e9839b928539"
}
