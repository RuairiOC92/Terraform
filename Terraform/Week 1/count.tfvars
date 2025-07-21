## Create 5 s3 buckets with count ##

resource "aws_s3_bucket" "my-super-awesome-test-bucket" {
 count = 5
 bucket = "my-super-awesome-test-bucket-$(count.index + 1)"
}

output "bucket_ids"{
    value = aws_s3_bucket.my-super-awesome-test-bucket[*].id
    description = "List of all S3 bucket IDs created"
}

output "bucket_arns"{
    value = aws_s3_bucket.my-super-awesome-test-bucket[*].arn
    description = "List of all S3 bucket arns created"
}


## Create 3 IAM users with count ##

resource "iam_user" "terraform_user" {
    count = 3
    name = "terraform-user (count.index + 1)"
}

output "iam_names" {
    value = iam_user.terraform_user.names
    description = "List of all IAM user names created"
}
