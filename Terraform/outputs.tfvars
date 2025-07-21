
## Latest AWS availability zones ##

data "aws_availability_zone" {
    state = "available"
}

output "availability_zones" {
    value = data.aws_availability_zones.availability_zones.names
    description = "List of all availability zones"
}


## Latest Ubuntu Image ##

data "aws_ami" "ubuntu" {
    most_recent = true 

    filter {
        name = "name"
        value = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noblet-24.04-amd64-server-*"]
    }

    owners = ["099720109477"] # Canonical

}

 output "aws_ami_id" {
        value = data.aws_ami.ubuntu.id
        description = "Latest Ubuntu image"
    }


## Current AWS Account ID ##

data "aws_current_id" "current" {
    output "account_id" {
        value = data.aws_current_id.current.account_id
        description = "This is the current AWS account ID"    }

}

## Creating s3 Bucket ##

output "aws_s3_name" {
    value = aws_s3_bucket.backup.id
    description = "The name of the s3 bucket"
}

output "aws_s3_arn" {
    value = aws_s3_bucket.backup.arn
    description = "The name of the arn created"
}

## Create CIDR Block ##

output "vpc_id" {
    value = aws_vpc.main.id
    description = "ID of VPC created"
}

## Create Subnet ##

output "public_subnet" {
    value = aws_subnet.public_subnet.id
    description = "ID of Public Subnet created"
}

output "private_subnet" {
    value = aws_subnet.private_subnet.id 
    description = "ID of Private Subnet created"
}

## Create 5 s3 buckets with count ##

output "bucket_ids"{
    value = aws_s3_bucket.my-super-awesome-test-bucket[*].id
    description = "List of all S3 bucket IDs created"
}

output "bucket_arns"{
    value = aws_s3_bucket.my-super-awesome-test-bucket[*].arn
    description = "List of all S3 bucket arns created"
}

## Create 3 IAM users with count ##

output "iam_names" {
    value = aws_iam_user.terraform_user.names
    description = "List of all IAM user names created"
}

