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

## Create Dynamic ingress policy ##

variable "ingress_policy" {
  type = list(object({
    description = string
    to_port     = number
    from_port   = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      description = "Allow inbound ssh traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow inbound http traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow inbound https traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "iam_users" {
  description = "Create user list"
  type        = list(string)
  default     = ["Evgeny"]
}




