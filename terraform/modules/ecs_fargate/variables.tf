variable "project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "Region de AWS"
  type        = string
}

variable "vpc_id" {
  description = "VPC donde se despliega el servicio"
  type        = string
}

variable "public_subnets" {
  description = "Subnets publicas (para el ALB)"
  type        = list(string)
}

variable "private_subnets" {
  description = "Subnets privadas (para las tareas Fargate)"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security groups que se asignan al ALB"
  type        = list(string)
}

variable "app_security_group_ids" {
  description = "Security groups que se asignan a las tareas"
  type        = list(string)
}

variable "image" {
  description = "Imagen del contenedor (URI de ECR + tag)"
  type        = string
}

variable "database_url" {
  description = "Cadena de conexion a la base de datos"
  type        = string
  sensitive   = true
}

variable "container_port" {
  description = "Puerto del contenedor"
  type        = number
  default     = 8000
}

variable "cpu" {
  description = "CPU en unidades (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memoria en MB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Cantidad deseada de tareas"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimo de tareas para autoescalado"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximo de tareas para autoescalado"
  type        = number
  default     = 2
}