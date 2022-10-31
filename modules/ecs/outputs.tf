output "myECS" {
    value = aws_ecs_cluster.main_ecs_cluster
}

output "myService" {
    value = aws_ecs_service.main
}