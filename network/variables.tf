# ---- network/variables.tf ----

variable "vpc_cidr" {
  type = string
}

variable "public_cidr" {
  type = list(any)
}

variable "private_cidr" {
  type = list(any)
}

variable "max_subnets" {
  type = number
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}