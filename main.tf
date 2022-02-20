# ---- root/main.tf ----

module "network" {
    source = "./network"
    vpc_cidr = "10.123.0.0/16"
    region = var.aws_region
} 