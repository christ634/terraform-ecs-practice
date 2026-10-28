variable "identifier" {
  description = "Identificador de la instancia RDS"
  type        = string
}

variable "environment" {
  description = "Entorno"
  type        = string
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "db_user" {
  description = "Usuario master de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Password master de la base de datos"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC donde se crea el RDS"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets privadas para el grupo de subnets de la BD"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups con acceso al puerto 5432"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "Clase de instancia de la BD"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Almacenamiento en GB"
  type        = number
  default     = 20
}