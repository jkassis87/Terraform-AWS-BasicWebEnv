# ---- network/main.tf ----

# data "aws_availability_zones" "available" {}

resource "aws_vpc" "tftest_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tftest_vpc"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "tftest_public_subnet" {
  #count                   = 1
  vpc_id                  = aws_vpc.tftest_vpc.id
  cidr_block              = var.public_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "tftest_pub_subnet"
  }
}

resource "aws_subnet" "tftest_private_subnet" {
  count                   = 1
  vpc_id                  = aws_vpc.tftest_vpc.id
  cidr_block              = var.private_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone

  tags = {
    Name = "tftest_pub_subnet"
  }
}


resource "aws_internet_gateway" "tftest_igw" {
  vpc_id = aws_vpc.tftest_vpc.id

  tags = {
    Name = "tftest-IGW"
  }
}

resource "aws_route_table" "tftest_rt" {
  vpc_id = aws_vpc.tftest_vpc.id

  route {
    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.tftest_igw.id
  }

  tags = {
    Name = "tftest_Route_Table"
  }
}

resource "aws_security_group" "tftest_public_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tftest_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.tftest_vpc.cidr_block]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.tftest_vpc.cidr_block]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.tftest_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tftest_public_sg"
  }
}

