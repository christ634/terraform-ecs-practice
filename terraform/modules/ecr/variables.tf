variable "name" {
  description = "Nombre base del repositorio"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, staging, prod)"
  type        = string
}

variable "force_delete" {
  description = "Permitir eliminar el repo aunque tenga imágenes"
  type        = bool
  default     = false
}