//cluster
variable name {}
variable environment {}
//log group
variable log_lgr_name {}
//task definition
variable task_name {}
variable net_mode {}
variable ecs_type {}
variable container_cpu {}
variable container_memory {}
variable container_name {}
variable container_image {}
variable essential {}
variable container_port {}
variable container_host_port {}
variable protocol {}
variable log_driver {}
variable log_group_name {}
variable region {}
variable uridb {}
//rol for task exc
variable rol_name {}
//service
variable service_name {}
variable service_desired_count {}
variable deployment_minimum_healthy_percent {}
variable deployment_maximum_percent {}
variable health_check_grace_period_seconds {}
variable scheduling_strategy {}
variable aws_alb_target_group_arn {}
variable private_subnets {}
variable ecs_service_security_groups {}