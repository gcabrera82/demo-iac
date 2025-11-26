# Infraestructura como Código (IaC) – ppdemo-iac

Este repositorio contiene la infraestructura completa para desplegar un entorno web balanceado con Azure Load Balancer, dos servidores Linux con NGINX/PHP, una base de datos Azure SQL (Azure SQL Database) y la importación automática del archivo `demo.bacpac`.

El proyecto representa un entregable técnico real, completamente reproducible mediante **Terraform** (IaC) y automatizable vía **Azure DevOps Pipelines** o GitHub Actions.

---

## 🚀 Arquitectura final

```
Internet
   │
Azure Load Balancer (puerto 80)
   │
Web Subnet (2 VMs Linux Ubuntu)
   │     ├─ NGINX
   │     ├─ PHP + drivers sqlsrv
   │     └─ index.php (desde repo)
   │
Azure SQL (expuesto a Internet pero restringido SOLO a Web Subnet)
   │
Storage Account (bacpac)
```

---

## 📂 Estructura del repositorio

```
ppdemo-iac/
├─ terraform/
│  ├─ main.tf
│  ├─ variables.tf
│  ├─ outputs.tf
│  ├─ providers.tf
│  ├─ lb.tf
│  ├─ vm.tf
│  ├─ sql.tf
│  ├─ nsg.tf
│  ├─ network.tf
│  └─ tags.tf
├─ scripts/
│  ├─ cloud-init-web.sh
│  └─ import-bacpac.sh
└─ README.md
```

---

## 🧱 Componentes desplegados

✔ Load Balancer Público  
✔ Web Servers: Ubuntu + NGINX + PHP + sqlsrv drivers  
✔ Virtual Network + Subnets + NSG  
✔ Storage Account + Container `bacpac`  
✔ Azure SQL Server + Database + Firewall  
✔ Importación automática del `.bacpac`  
✔ Tags obligatorias en todos los recursos  
✔ Listo para CI/CD en Azure DevOps  

---

## 🚀 Despliegue local con Terraform

1. Login en Azure:

```
az login
az account set --subscription <SUBSCRIPTION_ID>
```

2. Ejecutar Terraform:

```
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

---

## 📦 Subir manualmente el `demo.bacpac`

```
az storage blob upload   --account-name <storage_name>   --container-name bacpac   --file demodb.bacpac   --name demo.bacpac
```

---

## 🔄 CI/CD con Azure DevOps (pipeline YAML)

Incluye:

- Terraform init  
- Terraform plan  
- Terraform apply  
- Requiere un **Service Connection** ARM  
- Usa variables seguras:  
  - ARM_CLIENT_ID  
  - ARM_CLIENT_SECRET  
  - ARM_TENANT_ID  
  - ARM_SUBSCRIPTION_ID  

---

## 🧪 Validación final

✔ IP pública del Load Balancer devuelve versión SQL  
✔ Balanceo entre las dos VMs  
✔ Conexión PHP → SQL operativa  
✔ Firewall SQL permite solo la Web Subnet  

---

## 🎯 Objetivo

Entregar una infraestructura completa, segura, automatizada y reproducible para evaluación técnica.  
