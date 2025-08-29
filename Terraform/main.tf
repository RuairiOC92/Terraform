provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

## Create CIDR Block ##

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    account_id  = "0123456789"
    environment = var.aws
  }
}

## Create Subnet ##

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

## Availability Zones ##

data "aws_availability_zones" "available" {}

## Latest Ubuntu Image ##

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
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
  name   = "security_rules"

  dynamic "ingress" {
    for_each = local.ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
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
  count  = 5
  bucket = "my-super-awesome-test-bucket-${count.index + 1}"
}

## Create 3 IAM users with count ##

resource "aws_iam_user" "terraform_user" {
  count = 3
  name  = "terraform-user-${count.index + 1}"
}



## Creating the dynamic block for ingress rules ##



resource "aws_security_group" "web_rules" {
  name        = "inbound security group"
  description = "Inbound Traffic"
  vpc_id      = "vpc-0247ae9e1b35384bd"

  dynamic "ingress" {
    for_each = var.ingress_policy
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }


  egress {
    description = "Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Using count to create IAM users ##

resource "aws_iam_user" "team_members" {
  count = length(var.iam_users)
  name  = var.iam_users[count.index]
}


## Security Groups Using Module ##

module "security_group_rule" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "security-group-modules"
  vpc_id = "vpc-0247ae9e1b35384bd"

  ingress_with_cidr_blocks = [
    {
      description = "Allow inbound ssh traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "Allow inbound http traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "Allow inbound https traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}


## IAM User Using Module ##

module "iam_users" {
  source   = "terraform-aws-modules/iam/aws//modules/iam-user"
  for_each = var.iam_users_module
  name     = each.value
}



