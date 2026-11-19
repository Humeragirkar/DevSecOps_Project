output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}


output "ecr_repository_url" {
  description = "Private ECR repository URL for the application"
  value       = aws_ecr_repository.app.repository_url
}


output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_secret_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
}

output "kms_key_arn" {
  value = aws_kms_key.main.arn
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "alarm_topic_arn" {
  value = aws_sns_topic.alarms.arn
}
