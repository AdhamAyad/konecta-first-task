variable "rds_password" {
  type      = string
  sensitive = true
  default   = "your_password_here" # استبدل بالقيمة الحقيقية أو اضبط متغير خارجي
}

resource "aws_rds_cluster" "reporting_agencia" {
  cluster_identifier = "rds-reporting-agencia-cluster-1"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.08.2"
  master_username    = "r_agen_adm"
  master_password    = var.rds_password
  backup_retention_period        = 7
  skip_final_snapshot            = true
  apply_immediately              = false
  copy_tags_to_snapshot          = true
  deletion_protection            = true
  enable_global_write_forwarding = false
  enable_local_write_forwarding  = false

  db_cluster_parameter_group_name = "rds-pg-aurora-mysql-8-cluster"
  db_subnet_group_name            = "rds-sntg-private"
  vpc_security_group_ids          = ["sg-0a7ac2836e60e0688"]
  kms_key_id                      = "arn:aws:kms:eu-west-1:370661022279:key/a4dd79c5-d2fb-42c5-a062-c46e9a4f0e37"

  lifecycle {
    ignore_changes = [
      master_password,
      serverlessv2_scaling_configuration
    ]
  }

  tags = {
    Name       = "rds-reporting-agencia-cluster-1"
    Project    = "Reporting Agencia"
    Country    = "Espana"
    Platform   = "Terraform"
    aws-backup = "yes"
  }
}


resource "aws_rds_cluster_instance" "reporting_agencia_node1" {
  identifier         = "rds-reporting-agencia-node-1"
  cluster_identifier = aws_rds_cluster.reporting_agencia.id
  instance_class     = "db.serverless"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.08.2"

  copy_tags_to_snapshot   = true
  db_parameter_group_name = "rds-pg-aurora-mysql-8-instance"
  db_subnet_group_name    = "rds-sntg-private"

  monitoring_interval                   = 60
  monitoring_role_arn                   = "arn:aws:iam::370661022279:role/ROLE-rds-monitoring-role"
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = "arn:aws:kms:eu-west-1:370661022279:key/0b81ec43-3716-43f2-a360-9a4d51821cce"
  performance_insights_retention_period = 7

  apply_immediately = false  # مطابق للـ state الحالي
  force_destroy     = false

  lifecycle {
    ignore_changes = [
      # لا حاجة لحقول إضافية لأن الـ state متطابق
    ]
  }

  tags = {
    Name     = "rds-reporting-agencia-node-1"
    Project  = "Reporting Agencia"
    Country  = "Espana"
    Platform = "Terraform"
  }
}

resource "aws_secretsmanager_secret" "aurora_mysql" {
  name                           = "access_rds_aurora_mysql"
  description                    = "Acceso para BBDD Aurora mysql del cliente Reporting_agencia"
  force_overwrite_replica_secret = false
  recovery_window_in_days        = 30

  lifecycle {
  ignore_changes = [
    description,
    recovery_window_in_days,
    force_overwrite_replica_secret
  ]
}

  tags = {
    Name     = "access_rds_aurora_mysql"
    Project  = "Reporting Agencia"
    Country  = "Espana"
    Platform = "Terraform"
  }
}
# resource "aws_secretsmanager_secret_version" "aurora_mysql_version" {
#   secret_id     = aws_secretsmanager_secret.aurora_mysql.id
#   secret_string = jsonencode({
#     username = aws_rds_cluster.reporting_agencia.master_username
#     password = var.rds_password
#     cluster  = aws_rds_cluster.reporting_agencia.endpoint
#   })
# }
