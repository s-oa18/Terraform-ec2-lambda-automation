# Scheduled rule to start EC2 at 9 AM UTC, Monday to Friday
resource "aws_cloudwatch_event_rule" "start_rule" {
  name                = "Start_rule"
  schedule_expression = "cron(0 9 ? * MON-FRI *)"
}

# Scheduled rule to stop EC2 at 5 PM UTC, Monday to Friday
resource "aws_cloudwatch_event_rule" "stop_rule" {
  name                = "Stop_rule"
  schedule_expression = "cron(0 17 ? * MON-FRI *)"
}

# Link the start rule to the start Lambda function
resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_rule.name
  target_id = "StartEC2Target"
  arn       = aws_lambda_function.start_ec2.arn
}

# Link the stop rule to the stop Lambda function
resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "StopEC2Target"
  arn       = aws_lambda_function.stop_ec2.arn
}

# Allow EventBridge to invoke the start Lambda
resource "aws_lambda_permission" "allow_start" {
  statement_id  = "AllowExecutionFromCWStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rule.arn
}

# Allow EventBridge to invoke the stop Lambda
resource "aws_lambda_permission" "allow_stop" {
  statement_id  = "AllowExecutionFromCWStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rule.arn
}
