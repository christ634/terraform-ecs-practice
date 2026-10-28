output "alb_dns" {
  description = "URL publica de la aplicacion"
  value       = "http://${module.ecs_fargate.alb_dns_name}"
}

output "ecs_cluster" {
  description = "Nombre del cluster ECS"
  value       = module.ecs_fargate.cluster_name
}

output "ecs_service" {
  description = "Nombre del servicio ECS"
  value       = module.ecs_fargate.service_name
}

output "ecr_repository_url" {
  description = "URI del repositorio ECR (para pushear la imagen)"
  value       = module.ecr.repository_url
}

output "rds_endpoint" {
  description = "Endpoint de la base de datos"
  value       = module.rds.endpoint
  sensitive   = true
}