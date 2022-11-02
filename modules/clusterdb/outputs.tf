output "db_cn_string" {
    //split(",",demo.mydempapp.outbound_ip_addresses)[1]
    //value = mongodbatlas_cluster.db-cluster.connection_strings.0.standard_srv
    value = split(".",mongodbatlas_cluster.db-cluster.connection_strings.0.standard_srv)[1]
}

output "db_user_o" {
    value = mongodbatlas_database_user.dbuser.username
}
