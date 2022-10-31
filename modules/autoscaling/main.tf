// with autoscaling the number of task can change dinamically base on demand
resource "aws_appautoscaling_target" "main_ecs_target_scaling" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.resource_id_autoscaling
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
}

// policy to scale based on memory
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = var.memory_pol_name
  policy_type        = var.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.main_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.main_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.main_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type_memory //type of metric taken
    }

    target_value       = var.memory_target_value // if task reaches this value of utilization autoscaling will be trigger
    scale_in_cooldown  = var.scale_in_cooldown   // time to pass btw autoscalings
    scale_out_cooldown = var.scale_out_cooldown
  }
}

// policy to scale based on cpu
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = var.cpu_pol_name
  policy_type        = var.autoscaling_policy_type
  resource_id        = aws_appautoscaling_target.main_ecs_target_scaling.resource_id
  scalable_dimension = aws_appautoscaling_target.main_ecs_target_scaling.scalable_dimension
  service_namespace  = aws_appautoscaling_target.main_ecs_target_scaling.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type_cpu
    }

    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}