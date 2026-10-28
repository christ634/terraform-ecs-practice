output "endpoint" {
  description = "Endpoint de conexion (host:puerto)"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Host de la base de datos"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Puerto de la base de datos"
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "SG de la base de datos"
  value       = aws_security_group.this.id
}