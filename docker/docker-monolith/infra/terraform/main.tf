provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

module "vpc" {
  source      = "../modules/vpc"
  sub       = var.sub
  #envare = var.envare
}

module "app" {
  source          = "../modules/app"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image  = var.app_disk_image
  subnet_id       = module.vpc.subnet_id
  #envare      = var.envare
}


module "db" {
  source          = "../modules/db"
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image   = var.db_disk_image
  subnet_id       = module.vpc.subnet_id
  #envare      = var.envare

}

