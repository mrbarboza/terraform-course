provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web" {
  name        = "WebServer-SG"
  description = "Security Group for Basic WebServer"

  dynamic "ingress" {
    for_each = ["80", "8080", "443", "8443"]
    content {
      description = "Allow HTTP port"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "WebServer-SG"
    Owner = "Miguel Barboza"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c2b8ca1dad447f8a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name  = "WebServer"
    Owner = "Miguel Barboza"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id

  tags = {
    Name  = "EIP WebServer"
    Owner = "Miguel Barboza"
  }
}
