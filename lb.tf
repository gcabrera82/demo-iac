resource "azurerm_lb" "lb" {
  name                = "${var.resource_group}-lb"
  resource_group_name = local.rg_name
  location            = local.rg_region
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicFrontend"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
  tags = local.common_tags
}

resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.resource_group}-lb-pip"
  resource_group_name = local.rg_name
  location            = local.rg_region
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "bepool"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "http_probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.lb.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicFrontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_assoc" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.web_nic[count.index].id
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bepool.id
}
