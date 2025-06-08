# Zip the start Lambda function
data "archive_file" "start_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/start_lambda.py"
  output_path = "${path.module}/lambda/start_lambda.zip"
}

# Zip the stop Lambda function
data "archive_file" "stop_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/stop_lambda.py"
  output_path = "${path.module}/lambda/stop_lambda.zip"
}

# Deploy Lambda function to start EC2
resource "aws_lambda_function" "start_ec2" {
  function_name = "start_ec2_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "start_lambda.lambda_handler"
  runtime       = "python3.10"
  filename      = data.archive_file.start_lambda_zip.output_path

  environment {
    variables = {
      INSTANCE_ID = aws_instance.auto_ec2.id
    }
  }
}

# Deploy Lambda function to stop EC2
resource "aws_lambda_function" "stop_ec2" {
  function_name = "stop_ec2_lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "stop_lambda.lambda_handler"
  runtime       = "python3.10"
  filename      = data.archive_file.stop_lambda_zip.output_path

  environment {
    variables = {
      INSTANCE_ID = aws_instance.auto_ec2.id
    }
  }
}
