## Create environment variables ##

variable "aws" {
  description = "AWS configuration variables dev/staging/prod"
  type        = string

  validation {
    error_message = "Value must be one of: dev, staging, prod"
    condition       = contains(["dev", "staging", "prod"], var.aws)
  }
}

## Create backup days variable ##

variable "backup_days" {
  type = number 
  default = 7

  validation {
    error_message = "Backups should occur between 1 and 30 days"
    condition = var.backup_days > 0 && var.backup_days <= 30
 }
}

## Enable encryption variable ##

variable "enable_encryption" {
  type = bool
  default = false
}

## Create availability zones variable ##

variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

## Create instance types variable ##

variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod  = "t2.small"
  }
} 