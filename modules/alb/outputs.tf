output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "lb_dns_name" {
  description = "El registro DNS asociado al Load Balancer"
  value       = format("http://%s", aws_lb.app_alb.dns_name)
}