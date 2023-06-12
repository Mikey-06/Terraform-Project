# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Development_VPC"
  }
}

# Variable for Subnet

variable "subnet_cidr_block" {
  description = "subnet_cidr_block"
}

variable "subnet_tag" {
  description = "subnet_tag"
}

# Create a Subnet
resource "aws_subnet" "dev_subnet" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-west-2a"

  tags = {
    Name = var.subnet_tag
  }
}

data "aws_vpc" "selected" {
  default = true
}

resource "aws_subnet" "stage" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "us-west-2b"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 2, 1)
}

output "vpc_id" {
  value = aws_vpc.dev.id
}

output "subnet_id" {
  value = aws_subnet.dev_subnet.id
}

output "vpc_main_route_table_id" {
  value = aws_vpc.dev.main_route_table_id
}