# ---- network/output.tf ----

output "vpc_id" {
  value = aws_vpc.tftest_vpc.id
}

output "public_sg" {
  value = aws_security_group.tftest_public_sg.id
}

output "public_subnet" {
  value = aws_subnet.tftest_public_subnet.*.id
}

output "private_sg" {
  value = aws_security_group.tftest_rds_sg.id
}

output "rds_subnet" {
  value = aws_db_subnet_group.tftest_rds_subnet_group.id
}

output "rds_sg" {
  value = aws_security_group.tftest_rds_sg.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.tftest_rds_subnet_group.*.name
}