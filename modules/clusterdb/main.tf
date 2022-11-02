terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.4.6"
    }
  }
}

resource "mongodbatlas_cluster" "db-cluster" {
  project_id              = var.atlas_project_id
  name                    = var.db_cluster_name

  # Provider Settings "block"
  provider_name = "TENANT" //free tier
  backing_provider_name = "AWS"
  provider_region_name = "US_EAST_1" //free tier
  provider_instance_size_name = "M0" //free tier
}


resource "mongodbatlas_database_user" "dbuser" {
  username           = var.db_user
  password           = var.db_password
  project_id         = var.atlas_project_id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
  }

}

resource "mongodbatlas_project_ip_access_list" "test" {
  project_id = var.atlas_project_id
  cidr_block = var.cidr
}