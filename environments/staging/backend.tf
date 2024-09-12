terraform {
  backend "s3" {
    bucket         = "edwinlabterraformstatebucket"
    key            = "ecs-fargate/staging/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "edwinlabterraformdynamo"
  }
}
