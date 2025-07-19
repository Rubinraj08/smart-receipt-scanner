variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 bucket name for receipts"
  default     = "smart-receipt-scanner-bucket"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "receipt-ocr-email"
}

variable "email_recipient" {
  description = "Email address to send receipt summary"
  default     = "rubinrajrubinraj7@gmail.com"
}
