# Terraform AWS ECS Fargate Practice

Production-style Infrastructure as Code project that provisions a containerized FastAPI application on AWS using Terraform modules. Includes VPC networking, ECS Fargate, Application Load Balancer, RDS PostgreSQL, and ECR.

## Architecture

```text
Internet -> ALB (Public Subnets) -> ECS Fargate Tasks (Private Subnets)
                                      |-> RDS PostgreSQL (Private Subnets)
                                      |-> ECR (Container Images)
```

## Stack

- **IaC**: Terraform (modular design)
- **Compute**: AWS ECS Fargate
- **Networking**: VPC, NAT Gateway, Public/Private Subnets (Multi-AZ)
- **Load Balancing**: Application Load Balancer
- **Database**: Amazon RDS PostgreSQL
- **Registry**: Amazon ECR (with scan on push)
- **App**: FastAPI + PostgreSQL
- **Local Dev**: Docker Compose

## Project Structure

```text
.
├── app/                      # FastAPI application (multi-stage Dockerfile)
├── docker-compose.yml        # Local development environment
├── scripts/
│   └── build-and-push.sh     # Build and push to ECR
└── terraform/
    ├── main.tf               # Root module orchestration
    ├── modules/
    │   ├── ecr/              # ECR repository + lifecycle policy
    │   ├── rds/              # RDS PostgreSQL with security groups
    │   └── ecs_fargate/      # ECS cluster, task, service, ALB, autoscaling
    └── ...
```

## Quick Start (Local)

```bash
docker compose up -d --build
curl http://localhost:8000/health
```

## Deploy to AWS

```bash
cd terraform
terraform init
terraform plan
terraform apply

# Push image to ECR
./scripts/build-and-push.sh $(terraform output -raw ecr_repository_url) latest
```

## Key Concepts Practiced

- **Modular Terraform**: Reusable, composable modules with typed inputs/outputs
- **Secure Networking**: Private subnets for workloads/DB, security groups with least privilege
- **ECS Fargate**: Serverless containers with awsvpc networking
- **Auto Scaling**: Target tracking based on CPU utilization
- **Container Registry**: ECR with image scanning and lifecycle policies
- **Infrastructure Best Practices**: Tags, sensitive variables, health checks

## Author

[Christopher Cardozo](https://github.com/christ634)
