resource "azurerm_storage_account" "bacpac" {
  name                     = "${var.resource_group}stbacpac"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.common_tags
}

resource "azurerm_storage_container" "bacpac" {
  name                  = "bacpac"
  storage_account_name  = azurerm_storage_account.bacpac.name
  container_access_type = "blob"
}
