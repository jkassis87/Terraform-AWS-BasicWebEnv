# ---- root/main.tf ----

module "network" {
  source   = "./network"
  vpc_cidr = "10.123.0.0/16"
  availability_zone = "ap-southeast-2"
  public_cidr = "10.123.2.0/24"
  private_cidr = "10.123.7.0/24"
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
  db_subnet_group_name   = "tftest_pubsg"
  vpc_security_group_ids = []
}

