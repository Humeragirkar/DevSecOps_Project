terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  # Remote state with locking + encryption. Create the bucket/table once (out of band),
  # then uncomment. State contains sensitive metadata, so never keep it local in real use.
  # backend "s3" {
  #   bucket         = "my-org-tfstate"
  #   key            = "secure-app/dev/terraform.tfstate"
  #   region         = "ap-south-1"
  #   encrypt        = true
  #   kms_key_id     = "alias/tfstate"
  #   dynamodb_table = "tfstate-lock"
  # }
}

provider "aws" {
  region = var.aws_region

  # Governance: every taggable resource inherits these tags automatically.
  default_tags {
    tags = local.common_tags
  }
}
