resource "azurerm_mssql_server" "sqlsrv" {
  name                         = "${var.resource_group}-sqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = "sqladminuser"
  administrator_login_password = "SqlP@ssw0rd1234!"
  version                      = "12.0"

  tags = local.common_tags
}

resource "azurerm_mssql_database" "sqldb" {
  name                = "ppdemo-db"
  server_id           = azurerm_mssql_server.sqlsrv.id
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  sku_name            = "S0"

  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "allow_web_vms" {
  name        = "allow-web-vms"
  server_id   = azurerm_mssql_server.sqlsrv.id
  start_ip_address = "10.0.2.0"
  end_ip_address   = "10.0.2.255"
}


resource "null_resource" "import_bacpac" {
  depends_on = [
  azurerm_mssql_database.sqldb,
  azurerm_storage_container.bacpac
]

  provisioner "local-exec" {
    command = <<EOT
      az sql db import \
        --admin-user sqladminuser \
        --admin-password "SqlP@ssw0rd1234!" \
        --name ppdemo-db \
        --server ${azurerm_mssql_server.sqlsrv.name} \
        --resource-group ${azurerm_resource_group.rg.name} \
        --storage-key $(az storage account keys list --account-name ${azurerm_storage_account.bacpac.name} --query [0].value -o tsv) \
        --storage-key-type StorageAccessKey \
        --storage-uri "${azurerm_storage_account.bacpac.primary_blob_endpoint}bacpac/demo.bacpac"
    EOT
  }
}
