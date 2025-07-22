provider "aws" {
  region = "us-east-1"
}

## Create CIDR Block ##

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        account_id = "0123456789"
        environment = var.aws
    }
}

## Create Subnet ##

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

## Availability Zones ##

data "aws_availability_zones" "available"{}

## Latest Ubuntu Image ##

data "aws_ami" "ubuntu" {
    most_recent = true 

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    owners = ["099720109477"] # Canonical

}

## Create Security Group ##

locals {
    ports = [22, 80, 443]
}

resource "aws_security_group" "mysgroup" {
    vpc_id = aws_vpc.main.id
    name = "security_rules"

    dynamic "ingress" {
        for_each = local.ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }

    }
}

## Current AWS Account ID ##

data "aws_caller_identity" "current" {}

## Creating s3 Bucket ##

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "backup" {
  bucket = "${var.aws}-terraform-practice-${random_id.bucket_suffix.hex}"

  versioning {
    enabled = var.aws == "prod"
  }

  tags = {
  instance_type      = var.instance_types[var.aws]
  availability_zones = join("-", var.availability_zones)
  backups            = tostring(var.backup_days)
}
}

## Create 5 s3 buckets with count ##

resource "aws_s3_bucket" "my-super-awesome-test-bucket" {
 count = 5
 bucket = "my-super-awesome-test-bucket-${count.index + 1}"
}

## Create 3 IAM users with count ##

resource "aws_iam_user" "terraform_user" {
    count = 3
    name = "terraform-user-${count.index + 1}"
}






