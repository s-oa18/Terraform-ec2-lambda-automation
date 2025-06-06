resource "aws_iam_role" "lambda_exec" {
  name = "LambdaEC2ExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "attach-lambda-basic-execution"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "ec2_control" {
  name        = "LambdaEC2ControlPolicy"
  description = "Allow Lambda to start/stop EC2"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_control_attach" {
  name       = "attach-ec2-control"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.ec2_control.arn
}
