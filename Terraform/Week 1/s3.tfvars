

resource "aws_s3_bucket" "backup" {
  bucket = "${var.environment}-terraform-practice-${random_suffix}"

  versioning {
    condition = var.aws == "prod"
    enabled   = true
  }

  tags = {
    instance_types = var.instance_types[var.aws]
    availability_zones = var.avaibility_zones 
    backups = var.backup_days
  }
}

output "backup" {
    value = aws_s3_bucket.backup.id
    description = "The name of the s3 bucket created for backups"
}


 