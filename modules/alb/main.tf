# resource "aws_lb" "app_alb" {
#   name               = "app-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.security_group]
#   subnets            = var.subnets
# }

# resource "aws_lb_target_group" "app_tg" {
#   name     = "app-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#   target_type = "ip"
# }

# resource "aws_lb_listener" "app_listener" {
#   load_balancer_arn = aws_lb.app_alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }
