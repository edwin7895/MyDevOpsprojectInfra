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
