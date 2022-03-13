# ---- root/main.tf ----

module "network" {
  source            = "./network"
  vpc_cidr          = local.vpc_cidr
  #availability_zone = "ap-southeast-2a"
  public_cidr       = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidr      = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  #rds_availability_zone = "ap-southeast-2c"
  public_sn_count  = 1
  private_sn_count = 2
  max_subnets      = 20
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
  db_subnet_group_name   = module.network.db_subnet_group_name[0]
  vpc_security_group_ids = []
}

module "compute" {
  source         = "./compute"
  public_sg      = module.network.public_sg
  public_subnet  = module.network.public_subnet
  instance_count = 1
  instance_type  = "t2.micro"

  key_name = "tftest_sshkey" 
  public_key_path     = "~/.ssh/id_rsa.pub"
}