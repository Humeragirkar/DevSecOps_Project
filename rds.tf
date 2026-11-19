resource "aws_db_subnet_group" "main" {
  name       = "${local.name}-db"
  subnet_ids = aws_subnet.private_db[*].id
  tags       = { Name = "${local.name}-db-subnets" }
}

resource "aws_db_parameter_group" "main" {
  name_prefix = "${local.name}-pg-"
  family      = var.db_parameter_family

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "immediate"
  }
  parameter {
    name         = "log_connections"
    value        = "1"
    apply_method = "immediate"
  }
  parameter {
    name         = "log_disconnections"
    value        = "1"
    apply_method = "immediate"
  }

  lifecycle { create_before_destroy = true }
}

resource "aws_db_instance" "main" {
  identifier     = "${local.name}-pg"
  engine         = "postgres"
  engine_version = var.db_engine_version != "" ? var.db_engine_version : null
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.db_username

  # Password is generated and stored by RDS in Secrets Manager (KMS-encrypted).
  # It never appears in Terraform code, variables or plan output.
  manage_master_user_password   = true
  master_user_secret_kms_key_id = aws_kms_key.main.arn

  # Encryption at rest
  storage_encrypted = true
  kms_key_id        = aws_kms_key.main.arn

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type          = "gp3"

  # Network isolation
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = var.db_multi_az
  parameter_group_name   = aws_db_parameter_group.main.name

  iam_database_authentication_enabled = true

  # Resilience & lifecycle
  backup_retention_period    = var.db_backup_retention_days
  backup_window              = "21:00-22:00"
  maintenance_window         = "sun:22:30-sun:23:30"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = false
  final_snapshot_identifier  = "${local.name}-pg-final"

  # Monitoring
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = 0
  performance_insights_enabled    = false

  tags = { Name = "${local.name}-pg" }
}
