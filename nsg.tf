resource "azurerm_network_security_group" "web_nsg" {
  name                = "${var.resource_group}-web-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.common_tags
}

# Permitir tráfico desde el Load Balancer al puerto 80
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "allow-http-80"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_range      = "80"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.web_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# (Opcional) Permitir SSH desde tu IP pública
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow-ssh-22"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "Internet"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  network_security_group_name = azurerm_network_security_group.web_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# Permitir tráfico interno dentro de la VNet
resource "azurerm_network_security_rule" "allow_vnet_inbound" {
  name                        = "allow-vnet-inbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  network_security_group_name = azurerm_network_security_group.web_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

###############################################
# Asociar el NSG a la Subnet donde van las VMs
###############################################

resource "azurerm_subnet_network_security_group_association" "web_subnet_assoc" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}
