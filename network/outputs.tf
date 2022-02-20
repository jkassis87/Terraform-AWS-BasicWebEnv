# ---- network/output.tf ----

output "vpc_id" {
    value = aws_vpc.tftest_vpc.id
} 