

resource "aws_s3_bucket" "backup" {
  bucket = "${var.environment}-terraform-practice-${random_suffix}"

  versioning {
    condition = var.aws == "prod"
    enabled   = true
  }

  tags = {
    instance_types = var.instance_types
    availability_zones = var.avaibility_zones 
    backups = var.backup_days
  }
}


output "aws_s3_name" {
    value = aws_s3_bucket.backup.id
    description = "The name of the s3 bucket"
}

output "aws_s3_arn" {
    value = aws_s3_bucket.backup.arn
    description = "The name of the arn created"
}

 