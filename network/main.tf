# ---- network/main.tf ----
resource "aws_vpc" "tftest_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "tftest_vpc"
    }
} 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tftest_vpc.id
  
  tags = {
    Name = "tftest-IGW"
  }
}