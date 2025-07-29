## Create environment variables ##

variable "aws" {
  description = "AWS configuration variables dev/staging/prod"
  type        = string

  validation {
    error_message = "Value must be one of: dev, staging, prod"
    condition     = contains(["dev", "staging", "prod"], var.aws)
  }
}

## Create backup days variable ##

variable "backup_days" {
  type    = number
  default = 7

  validation {
    error_message = "Backups should occur between 1 and 30 days"
    condition     = var.backup_days > 0 && var.backup_days <= 30
  }
}

## Enable encryption variable ##

variable "enable_encryption" {
  type    = bool
  default = false
}

## Create availability zones variable ##

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

## Create instance types variable ##

variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod = "t2.small"
  }
}

## Create 5 s3 buckets with names ##

variable "named_instances" {
  type = list(object({
    name   = string
    instance_type   = string
    ami_id = string
  }))

  default = [{
    name   = "Ruairi OConnell"
    instance_type   = " t2.micro"
    ami_id = "ami-000ec6c25978d5999"
    },
    {
      name   = "Alan Hollowed"
      instance_type   = "t2.micro"
      ami_id = "ami-000ec6c25978d5999"
    },
    {
      name   = "Aoife Kelly"
      instance_type   = "t2.micro"
      ami_id = "ami-000ec6c25978d5999"
    },
    {
      name   = "Evgeny "
      instance_type   = "t2.micro"
      ami_id = "ami-000ec6c25978d5999"
    },
    {
      name   = "Anton Sidelnekov"
      instance_type   = "t2.micro"
      ami_id = "ami-000ec6c25978d5999"
  }]
}

variable "vpc_id" {
  type = string
  default = "vpc-0247ae9e1b35384bd"
}
