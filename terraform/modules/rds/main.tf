resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.identifier}-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Acceso a la base de datos ${var.identifier}"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.identifier}-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "pg" {
  count = length(var.allowed_security_group_ids)

  security_group_id            = aws_security_group.this.id
  referenced_security_group_id = var.allowed_security_group_ids[count.index]
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = "postgres"
  engine_version = "16.4"
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  storage_encrypted     = true
  max_allocated_storage = 0

  db_name  = var.db_name
  username = var.db_user
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  multi_az            = false
  skip_final_snapshot = true
  deletion_protection = false

  performance_insights_enabled = false

  tags = {
    Name        = var.identifier
    Environment = var.environment
  }
}