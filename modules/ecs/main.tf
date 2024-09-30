resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "frontend_app_task" {
  family                   = "frontend-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = file("${path.module}/container_definitions.json")
}

resource "aws_ecs_service" "frontend_app_service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "frontend-app"
    container_port   = 80
  }
}
