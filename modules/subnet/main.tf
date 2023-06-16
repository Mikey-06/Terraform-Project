# Create a Subnet
resource "aws_subnet" "myapp-subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.env_prefix}-subnet"
  }
}

# Create Internet Getway
resource "aws_internet_gateway" "myapp-internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-internet_gateway"
  }
}

# Create Route Table
resource "aws_route_table" "myapp-route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-internet_gateway.id
  }

  tags = {
    Name = "${var.env_prefix}-route_table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "myapp-route_table_association-subnet" {
  subnet_id      = aws_subnet.myapp-subnet.id
  route_table_id = aws_route_table.myapp-route_table.id
} 