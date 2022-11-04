// ecs cluster

module "esc_cluster" {
    source = "./modules/ecs"
    //cluster
    name = "${var.name}-cluster-${var.environment}"
    environment = var.environment
    //log group
    log_lgr_name = "${var.name}-lgr-${var.environment}"
    //task definition
    task_name = "${var.name}-task-${var.environment}"
    net_mode = var.net_mode
    ecs_type = var.ecs_type
    container_cpu = var.container_cpu
    container_memory = var.container_memory
    container_name = "${var.name}-container-${var.environment}"
    container_image = var.container_image //image uploaded to ecr, check if you can  upload an initial image when creating a ecr repo
    essential = var.essential
    container_port = var.container_port
    container_host_port = var.container_host_port
    protocol = var.protocol
    log_driver = var.log_driver
    log_group_name = "${var.name}-cluster_group-${var.environment}"
    region = var.region
    uridb = module.atlas-cluster.db_cn_string //---------------------------------------------------
    //rol for task exc
    rol_name = "${var.name}-cluster-rol-${var.environment}"
    //service
    service_name = "${var.name}-service-${var.environment}"
    service_desired_count = var.service_desired_count
    deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
    deployment_maximum_percent = var.deployment_maximum_percent
    health_check_grace_period_seconds = var.health_check_grace_period_seconds
    scheduling_strategy = var.scheduling_strategy
    aws_alb_target_group_arn = module.load_balancer.myAlbGr.arn
    private_subnets = [module.private_subnet_1.mySubnet, module.private_subnet_2.mySubnet] //passing my two private subnet
    ecs_service_security_groups = [aws_security_group.ecs_tasks_sg]
    depends_on = [module.load_balancer]
}