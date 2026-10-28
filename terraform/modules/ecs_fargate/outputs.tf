output "cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.this.name
}

output "task_definition_arn" {
  description = "ARN de la task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "alb_dns_name" {
  description = "DNS del Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "ARN del ALB"
  value       = aws_lb.this.arn
}