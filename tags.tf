#########################################
# tags.tf — Tags estándar del proyecto
#########################################

locals {
  common_tags = {
    CreadoPor       = var.creado_por
    FechaDeCreacion = var.fecha_creacion
    Proposito       = var.proposito
  }
}

variable "creado_por" {
  type        = string
  description = "Nombre del creador del recurso"
}

variable "fecha_creacion" {
  type        = string
  description = "Fecha de creación del recurso"
}

variable "proposito" {
  type        = string
  description = "Propósito del recurso"
}
