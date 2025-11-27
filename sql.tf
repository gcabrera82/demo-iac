##############################################
# SQL Server + SQL DB + Firewall
##############################################

resource "azurerm_mssql_server" "sqlsrv" {
  name                         = "ent1sqlsrv"
  resource_group_name          = local.rg_name
  location                     = "westus2"
  administrator_login          = "sqladminuser"
  administrator_login_password = "SqlP@ssw0rd1234!"
  version                      = "12.0"

  tags = local.common_tags
}

resource "azurerm_mssql_database" "sqldb" {
  name      = "ppdemo-db"
  server_id = azurerm_mssql_server.sqlsrv.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
  sku_name  = "S0"

  tags = local.common_tags
}

# Firewall para permitir Azure Services (requerido por Import)
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.sqlsrv.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Firewall para permitir VNET (opcional)
resource "azurerm_mssql_firewall_rule" "allow_web_vms" {
  name             = "allow-web-vms"
  server_id        = azurerm_mssql_server.sqlsrv.id
  start_ip_address = "10.0.2.0"
  end_ip_address   = "10.0.2.255"
}

##############################################
# IMPORTACIÓN DEL BACPAC 
##############################################

resource "null_resource" "import_bacpac" {
  depends_on = [
    azurerm_mssql_database.sqldb,
    azurerm_storage_container.bacpac,
    azurerm_mssql_firewall_rule.allow_azure
  ]

  provisioner "local-exec" {
    interpreter = ["powershell", "-Command"]

    command = <<EOT

# Obtener la Storage Key
$storageKey = az storage account keys list `
    --account-name ${azurerm_storage_account.bacpac.name} `
    --query "[0].value" -o tsv

Write-Host "KEY OBTENIDA:" $storageKey

# URL del BACPAC que subiste
$bacpacUrl = "https://${azurerm_storage_account.bacpac.name}.blob.core.windows.net/bacpac/demo-valid.bacpac"

Write-Host "IMPORTANDO DESDE:" $bacpacUrl

# Importación real
az sql db import `
  --admin-user sqladminuser `
  --admin-password "SqlP@ssw0rd1234!" `
  --name ppdemo-db `
  --server ent1sqlsrv `
  --resource-group ${local.rg_name} `
  --storage-key $storageKey `
  --storage-key-type StorageAccessKey `
  --storage-uri $bacpacUrl

EOT
  }
}
