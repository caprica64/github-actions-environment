# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

  cloud {
    organization = "caprica"

    workspaces {
      #name = "GitHub-Actions-Environments-dev"
      prefix = "GitHub-Actions-Environments-"
    }
  }
}

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
    Name        = "My Dev bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
