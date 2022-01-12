resource "azurerm_resource_group" "djpythonapp1" {
    name = "test"
    location = "Central US"
}

resource "azurerm_app_service_plan" "djpythonapp1" {
    name = "djpythonapp1-test"
    location = "Central US"
    resource_group_name = azurerm_resource_group.djpythonapp1.name
    kind = "Linux"
    reserved = false

    zone_redundant = false
    per_site_scaling = false
    

    sku {
      tier = "Free"
      size = "F1"
      capacity = 1
    }

}