resource "azurerm_network_interface" "web_nic" {
  count               = 2
  name                = "nic-web-${count.index+1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "web" {
  count               = 2
  name                = "vm-web-${count.index+1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2ms"

  admin_username = "azureuser"
  admin_password = "P@ssw0rd1234!" # mejor usar ssh key y variables seguras

  network_interface_ids = [azurerm_network_interface.web_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = filebase64("${path.module}/scripts/cloud-init-web.sh")
  tags = local.common_tags
}
