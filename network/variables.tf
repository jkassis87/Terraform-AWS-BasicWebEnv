# ---- network/variables.tf ----

variable "vpc_cidr" {
  type = string
} 

variable "public_cidr" {
  type = string
}

variable "private_cidr" {
  type = string
}

variable "availability_zone" {
  type = string
}
