resource "azurerm_virtual_network" "vnet" {
  name                = "${local.rg_name}-vnet"
  resource_group_name = local.rg_name
  address_space       = ["10.0.0.0/16"]
  location            = local.rg_region
  tags                = local.common_tags
}

resource "azurerm_subnet" "web" {
  name                 = "subnet-web"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


