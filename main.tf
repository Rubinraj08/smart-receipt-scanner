provider "aws" {
  region = "ap-south-1"
}

# S3 Bucket
resource "aws_s3_bucket" "receipts" {
  bucket = "smart-receipt-scanner-bucket"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Basic Lambda Permissions
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Textract Access
resource "aws_iam_role_policy_attachment" "textract_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
}

# Allow SES Access
resource "aws_iam_role_policy_attachment" "ses_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# Allow Lambda to access S3 (GetObject & ListBucket)
resource "aws_iam_role_policy" "lambda_s3_list_and_get" {
  name = "lambda-s3-list-and-get"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::smart-receipt-scanner-bucket",
          "arn:aws:s3:::smart-receipt-scanner-bucket/*"
        ]
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "receipt_lambda" {
  function_name = "receipt-ocr-email"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda.zip"
  timeout       = 10
  memory_size   = 256

  environment {
    variables = {
      EMAIL_RECIPIENT = "rubinrajrubinraj7@gmail.com"
    }
  }
}

# Lambda Permission for S3 Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.receipt_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.receipts.arn
}

# S3 Bucket Notification (trigger Lambda on upload)
resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = aws_s3_bucket.receipts.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.receipt_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
