data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-id"
    values = var.availability_zone_ids
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = "${var.project}-${var.environment}"
  azs  = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  https_enabled = var.acm_certificate_arn != ""
  nat_count     = var.single_nat_gateway ? 1 : var.az_count

  common_tags = {
    Project            = var.project
    Environment        = var.environment
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
    ManagedBy          = "terraform"
  }
}
