# smart-receipt-scanner
Serverless OCR system that reads receipts from S3 and emails extracted text using AWS Lambda, Textract &amp; SES

# Smart Receipt Scanner 🧾🚀

This is a serverless OCR pipeline using AWS Lambda, Textract, S3, and SES.

## Features
- Upload receipt to S3 → triggers Lambda
- Lambda reads image using Textract
- Extracted text is emailed using Amazon SES

## Stack
- AWS S3
- AWS Lambda (Python 3.11)
- AWS Textract
- AWS SES
- Terraform

## Setup
- Configure `variables.tf`
- Run `terraform init && terraform apply`

## Author
Rubinraj | [rubinrajrubinraj7@gmail.com](mailto:rubinrajrubinraj7@gmail.com)

