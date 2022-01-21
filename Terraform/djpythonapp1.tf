provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "djpythonapp1" {
  name     = "test" #make this a parameter
  location = "Central US"
}

resource "azurerm_app_service_plan" "djpythonapp1" {
  name                = "djpythonapp1"
  location            = "Central US"
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
  name                = "djpythonapp1"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.djpythonapp1.name
  application_type = "other"
}

resource "azurerm_app_service" "djpythonapp1" {
  name                = "djpythonapp1"
  location            = "Central US"
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