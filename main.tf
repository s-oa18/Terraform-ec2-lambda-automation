resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # for demo; restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "lamda_ec2" {
  ami = "ami-03400c3b73b5086e9"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "AutoEC2"
  }
}

# Create s3 bucket to store lambda function
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "ec2-lambda-functions-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Upload start Lambda
resource "aws_lambda_function" "start_ec2" {
  function_name = "StartEC2Instance"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.start_lambda.key
  handler       = "start_ec2.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 10

  environment {
    variables = {
      INSTANCE_ID = aws_instance.lamda_ec2.id
    }
  }
}

# Upload stop Lambda
resource "aws_lambda_function" "stop_ec2" {
  function_name = "StopEC2Instance"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_object.stop_lambda.key
  handler       = "stop_ec2.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 10

  environment {
    variables = {
      INSTANCE_ID = aws_instance.lamda_ec2.id
    }
  }
}

#Upload start Lambda function file
resource "aws_s3_object" "start_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "start_ec2.zip"
  source = "${path.module}/lambda/start_ec2.zip"
}

# Upload Stop Lambda function file
resource "aws_s3_object" "stop_lambda" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "stop_ec2.zip"
  source = "${path.module}/lambda/stop_ec2.zip"
}