provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "terraform-ecs-practice"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

locals {
  project        = "terraform-ecs-practice"
  name_prefix    = "${local.project}-${var.environment}"
  container_port = 8000

  azs             = var.availability_zones
  private_subnets = [for idx, az in local.azs : cidrsubnet(var.vpc_cidr, 8, idx)]
  public_subnets  = [for idx, az in local.azs : cidrsubnet(var.vpc_cidr, 8, idx + 100)]
}

# ---------------------------------------------------------------------------
# Networking
# ---------------------------------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = "${local.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "ALB publico"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP desde internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Tareas del servicio"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Desde el ALB"
    from_port       = local.container_port
    to_port         = local.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------------------------------------------------------
# Registro de la imagen
# ---------------------------------------------------------------------------

module "ecr" {
  source      = "./modules/ecr"
  name        = local.project
  environment = var.environment
}

# ---------------------------------------------------------------------------
# Base de datos
# ---------------------------------------------------------------------------

module "rds" {
  source      = "./modules/rds"
  identifier  = "${local.name_prefix}-db"
  environment = var.environment

  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  allowed_security_group_ids = [aws_security_group.app.id]
}

# ---------------------------------------------------------------------------
# Servicio ECS Fargate
# ---------------------------------------------------------------------------

module "ecs_fargate" {
  source = "./modules/ecs_fargate"

  project         = local.project
  environment     = var.environment
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  alb_security_group_ids = [aws_security_group.alb.id]
  app_security_group_ids = [aws_security_group.app.id]

  image          = "${module.ecr.repository_url}:${var.app_version}"
  database_url   = "postgresql://${var.db_user}:${var.db_password}@${module.rds.endpoint}/${var.db_name}"
  container_port = local.container_port
  cpu            = var.app_cpu
  memory         = var.app_memory
  desired_count  = var.desired_count
  min_capacity   = 1
  max_capacity   = 2
}