output "db_cn_string" {
    value = mongodbatlas_cluster.db-cluster.connection_strings.0.standard_srv
}

output "db_user_o" {
    value = mongodbatlas_database_user.dbuser.username
}
