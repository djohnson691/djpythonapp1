provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

variable "resource_group_name" {
  type = string
}

variable "app_service_plan_name" {
  type = string
}

variable "app_insights_name" {
  type = string
}

variable "app_service_name" {
  type = string
}

variable "location" {
  type = string
}

resource "azurerm_resource_group" "djpythonapp1" {
  name     = var.resource_group_name
  location = "Central US"
}

resource "azurerm_app_service_plan" "djpythonapp1" {
  name                = var.app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.djpythonapp1.name
  kind                = "Linux"
  reserved            = true

  zone_redundant   = false
  per_site_scaling = false


  sku {
    tier     = "Free"
    size     = "F1"
    capacity = 1
  }

}

resource "azurerm_application_insights" "djpythonapp1" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.djpythonapp1.name
  application_type = "other"
}

resource "azurerm_app_service" "djpythonapp1" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.djpythonapp1.name
  app_service_plan_id = azurerm_app_service_plan.djpythonapp1.id
  site_config {
    linux_fx_version = "PYTHON|3.9"
    use_32_bit_worker_process = true
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.djpythonapp1.instrumentation_key
  }
}