provider "aws" {
  access_key = "<YOUR_ACCESSKEY>"
  secret_key = "<YOUR_SECRETKEY>"
  region = "<REGION>"
}

resource "aws_instance" "web" {
  ami = "<AMI>"
  instance_type = "t3.micro"

  subnet_id = "<SUBNET>"
  vpc_security_group_ids = ["<SECURITY_GROUP>"]

  tags = {
  "Identity" = "<IDENTITY>"
  }
}