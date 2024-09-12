locals {
  workspace_key = "${terraform.workspace}"
}

terraform {
  backend "s3" {
    bucket         = "edwinlabterraformstatebucket"
    key            = "ecs-fargate/${local.workspace_key}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "edwinlabterraformdynamo"
  }
}
