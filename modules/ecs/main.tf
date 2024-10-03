resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

## Frontend resources ##
resource "aws_ecs_task_definition" "frontend_app_task" {
  family                   = "frontend-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = file("${path.module}/frontend_container_definitions.json")
}

resource "aws_ecs_service" "frontend_app_service" {
  name            = "frontend-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.frontend_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "frontend-app"
    container_port   = 5001
  }
  depends_on = [ aws_cloudwatch_log_group.ecs_frontend_log_group ]
}

resource "aws_cloudwatch_log_group" "ecs_frontend_log_group" {
  name              = "/ecs/frontend-app"
  retention_in_days = 3  # Optional: Set the number of days to retain logs
}

## Backend resources ##
resource "aws_ecs_task_definition" "backend_app_task" {
  family                   = "backend-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = file("${path.module}/backend_container_definitions.json")
}

resource "aws_ecs_service" "backend_app_service" {
  name            = "backend-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.backend_app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_group]
    assign_public_ip = true
  }
  # load_balancer {
  #   target_group_arn = var.target_group_arn
  #   container_name   = "backend-app"
  #   container_port   = 8080
  # }
  depends_on = [ aws_cloudwatch_log_group.ecs_backend_log_group ]
}

resource "aws_cloudwatch_log_group" "ecs_backend_log_group" {
  name              = "/ecs/backend-app"
  retention_in_days = 3  # Optional: Set the number of days to retain logs
}


