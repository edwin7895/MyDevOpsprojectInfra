# # Create auto-scaling policy for ECS Service
# resource "aws_appautoscaling_target" "ecs_scaling_target" {
#   max_capacity       = var.max_capacity
#   min_capacity       = var.min_capacity
#   resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.frontend_app_service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_scale_up_policy" {
#   name               = "ecs-scale-up"
#   policy_type        = "StepScaling"
#   resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
#   service_namespace  = "ecs"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 300
#     metric_aggregation_type = "Average"
#     step_adjustment {
#       metric_interval_lower_bound = 0
#       scaling_adjustment          = 1
#     }
#   }
# }

# resource "aws_appautoscaling_policy" "ecs_scale_down_policy" {
#   name               = "ecs-scale-down"
#   policy_type        = "StepScaling"
#   resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
#   service_namespace  = "ecs"

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 300
#     metric_aggregation_type = "Average"
#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }
