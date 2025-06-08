# Display instance ID after deployment
output "instance_id" {
  value = aws_instance.auto_ec2.id
}

# Display Lambda names
output "start_lambda_name" {
  value = aws_lambda_function.start_ec2.function_name
}

output "stop_lambda_name" {
  value = aws_lambda_function.stop_ec2.function_name
}
