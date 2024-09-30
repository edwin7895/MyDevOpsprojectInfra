variable "cluster_name" {
  type    = string
  default = "ecs-fargate-cluster"
}

variable "execution_role_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "min_capacity" {
  default = 1
}

variable "max_capacity" {
  default = 3
}

variable "region" {
  default = "us-east-1"
}

