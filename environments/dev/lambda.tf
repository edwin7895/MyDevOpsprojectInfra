# Role para la Lambda
resource "aws_iam_role" "oddo_lambda_role" {
  name = "oddolambdaExecutionRole-${var.product_env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "scheduler.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy para permisos de la Lambda en S3 y CloudWatch Logs
resource "aws_iam_policy" "oddo_lambda_policy" {
  name        = "oddo_lambda_policy"
  description = "Policy oddolambda with S3 and CloudWatch permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.oddo_s3_bucket_name}",
          "arn:aws:s3:::${var.oddo_s3_bucket_name}/*",
          "arn:aws:s3:::${var.oddo_artifact_bucket}",
          "arn:aws:s3:::${var.oddo_artifact_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}


# Adjuntar la política al rol
resource "aws_iam_role_policy_attachment" "oddo_lambda_policy_attachment" {
  role       = aws_iam_role.oddo_lambda_role.name
  policy_arn = aws_iam_policy.oddo_lambda_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "oddo_lambda" {
  function_name = "odoo-opps-qa"
  s3_bucket     = var.oddo_artifact_bucket
  s3_key        = "ODDO-OPPS.zip"  
  role          = aws_iam_role.oddo_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  environment {
    variables = {
      S3_BUCKET_NAME = var.oddo_s3_bucket_name
    }

  }
  depends_on = [
    aws_iam_role_policy_attachment.oddo_lambda_policy_attachment
  ]
}


# Terraform code to create an EventBridge Scheduler
resource "aws_scheduler_schedule" "oddo_lambda_scheduler" {
  name                = "oddo-edwin-schedule"
  schedule_expression = "rate(1 minute)"
  flexible_time_window {
    mode = "OFF"
  }
  
  target {
    arn      = aws_lambda_function.oddo_lambda.arn
    role_arn = aws_iam_role.eventbridge_scheduler_role.arn
  }
}

# IAM Role for EventBridge Scheduler
resource "aws_iam_role" "eventbridge_scheduler_role" {
  name = "eventbridge_scheduler_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for EventBridge Scheduler to invoke Lambda
resource "aws_iam_policy" "eventbridge_scheduler_policy" {
  name        = "eventbridge_scheduler_execution_policy"
  description = "Policy for EventBridge Scheduler to invoke Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          aws_lambda_function.oddo_lambda.arn
        ]
      }
    ]
  })
}

# Attach policy to the role
resource "aws_iam_role_policy_attachment" "eventbridge_scheduler_policy_attachment" {
  role       = aws_iam_role.eventbridge_scheduler_role.name
  policy_arn = aws_iam_policy.eventbridge_scheduler_policy.arn
}
