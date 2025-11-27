resource "azurerm_storage_account" "bacpac" {
  name                     = "ppdemostbacpacsa"
  resource_group_name      = local.rg_name
  location                 = local.rg_region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Allow"  # Permite que SQL Server acceda al blob
  }

  tags = local.common_tags
}

resource "azurerm_storage_container" "bacpac" {
  name                  = "bacpac"
  storage_account_id    = azurerm_storage_account.bacpac.id
  container_access_type = "blob"
}
