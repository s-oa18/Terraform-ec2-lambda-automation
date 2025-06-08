# Create EC2 security group
resource "aws_security_group" "autoec2_sg" {
  name        = "autoec2-sg"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "autoec2-sg"
  }
}

# Create EC2 instance
resource "aws_instance" "auto_ec2" {
  ami                    = "ami-03400c3b73b5086e9"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.autoec2_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
