terraform {
  required_providers {
    aws = {
        source = "Hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region = "eu-west-1"
  
}