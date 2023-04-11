# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "4.52.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "3.4.3"
#     }
#   }
#   required_version = ">= 1.1.0"
# 
#   cloud {
#     organization = "caprica"
# 
#     workspaces {
#       name = "GitHub-Actions-Environments-dev"
#     }
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
  
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "caprica"

    workspaces {
      prefix = "GitHub-Actions-Environments-"
    }
  }
}


#TO-DO set up above to Cloud {} and use GitHub env vars


provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "random_bucket_name" {
  prefix = "github-actions-${var.environment}"
  length = 1
}

resource "aws_s3_bucket" "bucket" {
  bucket = random_pet.random_bucket_name.id

  tags = {
    Name        = "My GitHub Actions bucket"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

output "s3_bucket_name" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.bucket.id
}
