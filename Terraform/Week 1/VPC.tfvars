## Create CIDR Block ##

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        account_id = "0123456789"
        environment = var.aws
    }
}

## Create Subnet ##

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}

## Output VPC and Subnet ID's ##

output "vpc_id" {
    value = aws_vpc.main.id
    description = "ID of VPC created"
}

output "public_subnet" {
    value = aws_subnet.public_subnet.id
    description = "ID of Public Subnet created"
}

output "private_subnet" {
    value = aws_subnet.private_subnet.id 
    description = "ID of Private Subnet created"
}

## Create Security Group ##

locals {
    ports = [22, 80, 443]
}

resource "aws_security_group "mysgroup" {
    name = "security_rules"

    dynamic "ingress" {
        for_each = local.ports
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = [0.0.0.0/0]
        }

    }
}




