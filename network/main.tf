# ---- network/main.tf ----

data "aws_availability_zones" "available" {}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

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
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.tftest_vpc.id
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "tftest_pub_subnet"
  }
}

resource "aws_route_table_association" "tftest_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.tftest_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.tftest_rt.id
}


resource "aws_subnet" "tftest_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.tftest_vpc.id
  cidr_block              = var.private_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "tftest_private_subnet"
  }
}

resource "aws_db_subnet_group" "tftest_rds_subnet_group" {

  name       = "tftest_rds_subnet_group"
  subnet_ids = aws_subnet.tftest_private_subnet.*.id
  tags = {
    Name = "tftest_rds_sng"
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
    cidr_block = "0.0.0.0/0"
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "tftest_rds_sg" {
  name        = "MySQL"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tftest_vpc.id

  ingress {
    description      = "MySQL"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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