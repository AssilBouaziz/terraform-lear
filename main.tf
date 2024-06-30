provider "aws"{
    #region = "eu-west-3"
    #access_key = "AKIAZV05TCKNDYYDZPEI"
    #secret_key = "dJRnI+tGBxT/sHZZT5hxaDj1C6V9Th7Z32qAhHUk"
}

variable "cidr_blocks" {
  description = "cidr blocks and names tags for vpc and subnets"
  #default = "10.0.10.0/24"
  type = list(object({
    cidr_block = string
    name = string
  }))
}

#variable "vpc_cidr_block" {
#  description = "vpc cidr block"
#}

variable "environment" {
  description = "development environment"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name
    #vpc_env: "dev"
  }
}

resource "aws_subnet" "dev-subnet-1"{
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "eu-west-3"
    tags = {
    Name: var.cidr_blocks[1].name
  }
}

data "aws_vpc" "existing_vpc"{
    default = true
}

resource "aws_subnet" "dev-subnet-2"{
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"              # get the default vpc adresses range
    availability_zone = "eu-west-3"
    tags = {
    Name: "subnet-2-default"
  }
}

output "dev-vpc-id" {
  value       = aws_vpc.development-vpc.id 
  #sensitive   = true
  #description = "description"
  #depends_on  = []
}
 output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
 }