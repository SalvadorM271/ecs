output "db_cn_string" {
    //value = mongodbatlas_cluster.db-cluster.connection_strings.0.standard_srv
    value = split(".",mongodbatlas_cluster.db-cluster.connection_strings.0.standard_srv)[1]
    //mongodb+srv://development-db.qntsjuk.mongodb.net
    //dburi = "qntsjuk"
}

output "db_user_o" {
    value = mongodbatlas_database_user.dbuser.username
}
