variable "location" { default = "eastus" }
variable "resource_group" { default = "rg-ppdemo" }
variable "tags" {
  type = map(string)
  default = {
    "Creado Por"        = "Germán"
    "Fecha de creación" = "2025-11-25"
    "Propósito"         = "Challenge AutoScheduler"
  }
}
