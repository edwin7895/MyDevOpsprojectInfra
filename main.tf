module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "iam" {
  source = "./modules/iam"
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.subnet_ids
  security_group = module.security_groups.alb_security_group_id
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "ecs-cluster"
  execution_role_arn = module.iam.ecs_execution_role_arn
  subnets            = module.vpc.subnet_ids
  security_group     = module.security_groups.ecs_security_group_id
  target_group_arn   = module.alb.app_tg.arn
}

module "security_groups" {
  source  = "./modules/security_groups"
  vpc_id  = module.vpc.vpc_id
}

module "autoscaling" {
  source        = "./modules/autoscaling"
  min_capacity  = 1
  max_capacity  = 3
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
