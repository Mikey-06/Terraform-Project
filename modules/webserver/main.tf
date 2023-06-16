# Create Security Group
resource "aws_security_group" "myapp-sg" {
  name        = "${var.env_prefix}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_IP]

  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}

# Fetch AMI for EC2
data "aws_ami" "latest-redhat-linux-image" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9.2.0_HVM-*-x86_64-41-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] 
}

# Create 
resource "aws_key_pair" "myapp-key" {
  key_name   = "myapp-key"
  public_key = var.pub_key
}


# Create EC2 Instance
resource "aws_instance" "myapp-server" {
  ami           = "${data.aws_ami.latest-redhat-linux-image.id}"
  instance_type = var.instance_type
  security_groups = [aws_security_group.myapp-sg.id]
  subnet_id = var.subnet.id
  availability_zone = var.availability_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.myapp-key.id

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-server"
  }
}