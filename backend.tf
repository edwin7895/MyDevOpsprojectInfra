terraform {
  backend "s3" {
    bucket         = "edwinlabterraformstatebucket"         # Cambia por tu bucket S3
    key            = "ecs-fargate/${terraform.workspace}/terraform.tfstate"  # Se organiza por workspace
    region         = "us-east-1"                   # Cambia a tu región de AWS
    encrypt        = true                          # Para cifrar el estado
    dynamodb_table = "edwinlabterraformdynamo"             # Opcional: Tabla DynamoDB para bloquear el estado
  }
}
