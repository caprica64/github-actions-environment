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
      name = "GitHub-Actions-Environments-dev"
      #prefix = "GitHub-Actions-Environments" # <<-use when running multiple workspace environments
    }
  }
}

#  backend "remote" {} # <<-use end setting up terraform init -backend-config=config.remote.dev.tfbackend

#  Bellow used when running Terraform init with remote backend setup > https://developer.hashicorp.com/terraform/language/settings/backends/remote#init
#  backend "remote" {
#  hostname = "app.terraform.io"
#  organization = "caprica"

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


#
# Keeping original template resources as references, but they should not be used.
#
# data "aws_ami" "ubuntu" {
#   most_recent = true
# 
#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }
# 
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# 
#   owners = ["099720109477"] # Canonical
# }
# 
# resource "aws_instance" "web" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.web-sg.id]
# 
#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update
#               apt-get install -y apache2
#               sed -i -e 's/80/8080/' /etc/apache2/ports.conf
#               echo "Hello World" > /var/www/html/index.html
#               systemctl restart apache2
#               EOF
# }
# 
# resource "aws_security_group" "web-sg" {
#   name = "${random_pet.sg.id}-sg"
#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   // connectivity to ubuntu mirrors is required to run `apt-get update` and `apt-get install apache2`
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# 
# output "web-address" {
#   value = "${aws_instance.web.public_dns}:8080"
# }