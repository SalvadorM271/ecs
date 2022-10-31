// autoscaling
variable max_capacity {}
variable min_capacity {}
variable resource_id_autoscaling {}
variable scalable_dimension {}
variable service_namespace {}
// memory policy
variable memory_pol_name {}
variable autoscaling_policy_type {}
variable predefined_metric_type_memory {}
variable memory_target_value {}
variable scale_in_cooldown {}
variable scale_out_cooldown {}
// cpu policy
variable cpu_pol_name {}
variable predefined_metric_type_cpu {}
variable cpu_target_value {}