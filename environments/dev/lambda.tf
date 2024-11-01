# Role para la Lambda
resource "aws_iam_role" "oddo_lambda_role" {
  name = "oddolambdaExecutionRole-${var.product_env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
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
resource "aws_cloudwatch_event_rule" "oddo_lambda_schedule" {
  name                = "oddo-edwin-schedule"
  schedule_expression = "rate(1 minute)"
  description         = "Schedule to invoke the odoo-opps-qa Lambda every 1 minute."
}

resource "aws_cloudwatch_event_target" "oddo_lambda_target" {
  rule      = aws_cloudwatch_event_rule.oddo_lambda_schedule.name
  target_id = "oddo-opps-qa-target"
  arn       = aws_lambda_function.oddo_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge_to_invoke" {
  statement_id  = "AllowEventBridgeInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.oddo_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.oddo_lambda_schedule.arn
}