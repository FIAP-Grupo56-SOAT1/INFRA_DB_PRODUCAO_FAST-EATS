terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.23.1"
    }
  }

  backend "s3" {
    bucket = "bucket-fiap56-to-remote-state"
    key    = "aws-ec2-mongodb-fiap56/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      owner      = var.owner
      managed-by = var.managedby
    }
  }
}