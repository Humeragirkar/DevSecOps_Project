variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "secureapp"
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "test", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, stage, prod."
  }
}

# ---- Governance tags ----
variable "owner" {
  type        = string
  description = "Team or person accountable for the resources."
}

variable "cost_center" {
  type = string
}

variable "data_classification" {
  type    = string
  default = "confidential"
}

# ---- Network ----
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "Use 2 or 3 AZs for high availability."
  }
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "true = one NAT (cheaper, dev). false = one NAT per AZ (recommended for prod)."
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDR ranges permitted to access the ALB."
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "ACM cert ARN. If set: HTTPS listener + HTTP->HTTPS redirect. If empty: HTTP only (dev only)."
}

# ---- ECS ----
variable "container_image" {
  type        = string
  default     = "public.ecr.aws/nginx/nginx-unprivileged:stable"
  description = "Demo container image. Replace with an application image and pin by digest for production."
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "task_cpu" {
  type    = number
  default = 512
}

variable "task_memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 6
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "read_only_root_fs" {
  type        = bool
  default     = false
  description = "Set true for apps that do not write to the container filesystem (recommended)."
}

# ---- RDS ----
variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_engine_version" {
  type    = string
  default = ""
}

variable "db_parameter_family" {
  type    = string
  default = "postgres16"
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_max_allocated_storage" {
  type    = number
  default = 50
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_backup_retention_days" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Enable for production. Keep false only in disposable dev labs."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Allow Terraform to empty the ALB log bucket on destroy."
}

# ---- Observability ----
variable "log_retention_days" {
  type    = number
  default = 30
}

variable "alarm_email" {
  type        = string
  default     = ""
  description = "Email for alarm notifications (subscription must be confirmed)."
}
