variable "environment" {
  description = "Entorno (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "Region de AWS"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Zonas de disponibilidad"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_version" {
  description = "Tag de la imagen a desplegar (debe existir en ECR)"
  type        = string
  default     = "latest"
}

variable "app_cpu" {
  description = "CPU de la tarea (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "app_memory" {
  description = "Memoria de la tarea en MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Cantidad inicial de tareas"
  type        = number
  default     = 1
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "app"
}

variable "db_user" {
  description = "Usuario master de la base"
  type        = string
  default     = "app"
}

variable "db_password" {
  description = "Password master de la base (protege con tfvars o variable de entorno)"
  type        = string
  sensitive   = true
}