# ---- root/main.tf ----

module "network" {
  source   = "./network"
  vpc_cidr = "10.123.0.0/16"
}

module "database" {
  source                 = "./database"
  db_storage             = 10
  db_engine_version      = "5.7.22"
  db_instance_class      = "db.t2.micro"
  db_name                = "rancher"
  dbuser                 = var.dbuser
  dbpassword             = var.dbpassword
  db_identifier          = "tftest-db"
  skip_db_snapshot       = true
  db_subnet_group_name   = ""
  vpc_security_group_ids = []
}

