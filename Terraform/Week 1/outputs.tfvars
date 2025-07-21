
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