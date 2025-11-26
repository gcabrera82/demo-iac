resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
  tags = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  tags = local.common_tags
}

resource "azurerm_subnet" "web" {
  name                 = "subnet-web"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
