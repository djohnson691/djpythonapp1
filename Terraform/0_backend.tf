terraform {
  backend "azurerm" {
    storage_account_name = "djpythonapp1testtfstate"
    container_name       = "djpythonapp1"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c0e81386-05f1-4c94-b8e3-51b0bc486450"
  version         = ">= 2.0"
}
