# ------------------------------
# Resource Group
# ------------------------------
output "resource_group_name" {
  value = local.rg_name
}

# ------------------------------
# Networking
# ------------------------------
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "web_subnet_id" {
  value = azurerm_subnet.web.id
}

output "web_nsg_name" {
  value = azurerm_network_security_group.web_nsg.name
}

# ------------------------------
# Storage Account
# ------------------------------
output "storage_account_name" {
  value = azurerm_storage_account.bacpac.name
}

output "storage_container_bacpac" {
  value = azurerm_storage_container.bacpac.name
}

# ------------------------------
# SQL Server
# ------------------------------
output "sql_server_name" {
  value = azurerm_mssql_server.sqlsrv.name
}

output "sql_database_name" {
  value = azurerm_mssql_database.sqldb.name
}

output "sql_fqdn" {
  value = azurerm_mssql_server.sqlsrv.fully_qualified_domain_name
}

# ------------------------------
# Load Balancer
# ------------------------------
output "public_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "lb_name" {
  value = azurerm_lb.lb.name
}

output "lb_backend_pool" {
  value = azurerm_lb_backend_address_pool.bepool.id
}


# ------------------------------
# VMs Web
# ------------------------------
output "web_vm_names" {
  value = azurerm_linux_virtual_machine.web[*].name
}

output "web_vm_private_ips" {
  value = azurerm_network_interface.web_nic[*].private_ip_address
}
