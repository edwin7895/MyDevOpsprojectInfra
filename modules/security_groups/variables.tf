variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created."
  type        = string
}

variable "alb_ingress_cidr" {
  description = "The CIDR block allowed to access the ALB."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ecs_ingress_sg" {
  description = "The security group that will be allowed to access the ECS tasks (e.g., the ALB security group)."
  type        = string
  default     = null
}
