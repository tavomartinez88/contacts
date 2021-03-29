terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = ""
  region  = ""
}

// Create table on aws to handler contacts using golang
resource "aws_dynamodb_table" "dynamodb-contacts-golang-gm" {
  name           = "ContactGolangGm"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-contacts-go"
    Environment = "dev"
  }
}

resource "random_id" "unique_suffix" {
  byte_length = 2
}

//Create role to lambda
resource "aws_iam_role" "lambda_exec" {
  name_prefix = local.app_id

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "lambda_AmazonDynamoDBFullAccess" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

//Create lambda to new contacts

data "archive_file" "create-contact" {
  output_path = "../create-contact-aws-lambda/bin/create-contact.zip"
  source_file = "../create-contact-aws-lambda/bin/create-contact-aws-lambda"
  type = "zip"
}

variable "create-contact-app-name" {
  description = "Lambda Create Contact"
  default = "create-contact-go-gm"
}

variable "app_env" {
  description = "Application environment tag"
  default     = "dev"
}

locals {
  app_id = "${lower(var.create-contact-app-name)}-${lower(var.app_env)}-${random_id.unique_suffix.hex}"
}

resource "aws_lambda_function" "create-contact-lambda-aws" {
  filename = data.archive_file.create-contact.output_path
  function_name = local.app_id
  handler = "create-contact-aws-lambda"
  role = aws_iam_role.lambda_exec.arn
  source_code_hash = base64sha256(data.archive_file.create-contact.output_path)
  runtime = "go1.x"
}