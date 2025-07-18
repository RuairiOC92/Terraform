variable "aws" {
  description = "AWS configuration variables dev/staging/prod"
  type        = map(string)

validation {
  error_message = "Value must be one of: dev, staging, prod"
  condition       = contains (["dev"], ["staging"], ["prod"], var.aws)
 }
}

variable "backup_days" {
  type = number 
  default = 7

  validation {
    error_message = "Backups should occur between 1 and 30 days"
    condition = var.backups_days > 0 && var.backup_days <= 30
 }
}

variable "enable_encryption" {
  type = boolean
  default = false
}

variable "availability_zones" {
  type = list[String]
  default = [us-east-1a, us-east-1b]
}

variable "instance_types" {
  type = map(string)
  default = {
    var.aws  = "t2.micro"
    var.aws  = "t2.small"
  }
}