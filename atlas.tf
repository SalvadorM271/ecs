//atlas

module "atlas-cluster" {
  source = "./modules/clusterdb"
  atlas_public_key = var.atlas_public_key
  atlas_private_key = var.atlas_private_key
  atlas_project_id = var.atlas_project_id
  db_cluster_name = "${var.environment}-db"
  //db_user = var.db_user
  //db_password = var.db_password
  cidr = var.cidr
  environment = var.environment
}

output "dburi" {
  value = module.atlas-cluster.db_cn_string
}