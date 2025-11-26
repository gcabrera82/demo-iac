#!/usr/bin/env bash

set -e

# -----------------------------------------
# Obtención dinámica de valores desde Terraform
# -----------------------------------------

echo ">> Obteniendo valores desde Terraform..."

TF_DIR="terraform"

RESOURCE_GROUP=$(terraform -chdir=$TF_DIR output -raw resource_group_name)
SQL_SERVER_NAME=$(terraform -chdir=$TF_DIR output -raw sql_server_name)
STORAGE_ACCOUNT=$(terraform -chdir=$TF_DIR output -raw storage_account_name)

DATABASE_NAME="ppdemo-db"
CONTAINER="bacpac"
BACPAC_FILE="demo.bacpac"
SQL_ADMIN="sqladminuser"
SQL_PASSWORD="SqlP@ssw0rd1234!"

echo "=============================================="
echo "   Importando BACPAC a Azure SQL"
echo "=============================================="
echo "Resource Group: $RESOURCE_GROUP"
echo "SQL Server:     $SQL_SERVER_NAME"
echo "Storage:        $STORAGE_ACCOUNT"
echo "=============================================="

# Obtener Storage Key
echo ">> Obteniendo storage key..."
STORAGE_KEY=$(az storage account keys list \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" -o tsv)

if [ -z "$STORAGE_KEY" ]; then
  echo "ERROR: No se pudo obtener la storage key."
  exit 1
fi

# Ejecutar importación
echo ">> Ejecutando importación del BACPAC..."

az sql db import \
  --resource-group "$RESOURCE_GROUP" \
  --server "$SQL_SERVER_NAME" \
  --name "$DATABASE_NAME" \
  --storage-key "$STORAGE_KEY" \
  --storage-key-type "StorageAccessKey" \
  --storage-uri "https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER}/${BACPAC_FILE}" \
  --admin-user "$SQL_ADMIN" \
  --admin-password "$SQL_PASSWORD"

echo ""
echo "=============================================="
echo "   Importación completada exitosamente!"
echo "=============================================="
