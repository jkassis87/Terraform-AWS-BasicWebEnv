# ---- network/output.tf ----

output "vpc_id" {
  value = aws_vpc.tftest_vpc.id
} 

output "public_sg" {
  value = aws_security_group.tftest_public_sg.id
}

output "public_subnet" {
  value = aws_subnet.tftest_public_subnet.id
}