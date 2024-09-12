terraform {
  backend "s3" {
    bucket         = "edwinlabterraformstatebucket"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "edwinlabterraformdynamo"
  }
}
