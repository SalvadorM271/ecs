// autoscaling

module "autoscaling" {
    source = "./modules/autoscaling"
    // autoscaling
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
    resource_id_autoscaling = "service/${module.esc_cluster.myECS.name}/${module.esc_cluster.myService.name}"
    scalable_dimension = var.scalable_dimension
    service_namespace = var.service_namespace
    // memory policy
    memory_pol_name = "${var.name}-memory-policy-${var.environment}"
    autoscaling_policy_type = var.autoscaling_policy_type
    predefined_metric_type_memory = var.predefined_metric_type_memory
    memory_target_value = var.memory_target_value
    scale_in_cooldown = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    // cpu policy
    cpu_pol_name = "${var.name}-cpu-policy-${var.environment}"
    predefined_metric_type_cpu = var.predefined_metric_type_cpu
    cpu_target_value = var.cpu_target_value
}