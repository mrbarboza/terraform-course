provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  instance_tenancy = "default"

  tags = {
    Name = "prod-vpc"
    Owner = "Miguel Barboza"
  }
}

resource "aws_subnet" "prod-subnet-public-1" {
  vpc_id = "${aws_vpc.prod-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet-public-1"
    Owner = "Miguel Barboza"
  }
}

resource "aws_network_interface" "default" {
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
}

resource "aws_instance" "web-server" {
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = "${aws_network_interface.default.id}"
    device_index = 0
  }

  tags = {
    Name = "ubuntu-web-server"
    Owner = "Miguel Barboza"
  }
}