terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key ="******************"
  secret_key ="******************"
}

# Create a VPC
# wp-vpc = aws_vpc(cidr_block="10.88.0.0/16")

resource "aws_vpc" "wp_vpc" {
  cidr_block = "10.88.0.0/16"
  tags = {
      Name = "wp_vpc"
  }
}


# Create public subnet

resource "aws_subnet" "wordpress_public" {
  vpc_id     = aws_vpc.wp_vpc.id
  cidr_block = "10.88.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "wordpress_public"
  }
}

# Create private subnet 

resource "aws_subnet" "MySQL_private" {
  vpc_id     = aws_vpc.wp_vpc.id
  cidr_block = "10.88.2.0/24"

  tags = {
    Name = "MySQL_private"
  }
}

# Create routing table

resource "aws_route_table" "wordpress_rt_public" {
  vpc_id = aws_vpc.wp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }

  tags = {
    Name = "wordpress_rt_public"
  }
}

resource "aws_route_table_association" "a" {
 subnet_id = aws_subnet.wordpress_public.id
 route_table_id = aws_route_table.wordpress_rt_public.id
}

# Create route tables 

resource "aws_route_table" "wordpress_rt_private" {
  vpc_id = aws_vpc.wp_vpc.id


    route {
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.wordpress_nat.id
  }

  tags = {
    Name = "wordpress_rt_private"
  }
}

resource "aws_route_table_association" "b" {
 subnet_id = aws_subnet.MySQL_private.id
 route_table_id = aws_route_table.wordpress_rt_private.id
}

# Create internet gateway

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wp_vpc.id
  tags = {
      Name = "wordpress_igw"
  }
}

# Allocate elastic ip 

resource "aws_eip" "nat" {
  vpc = true
}

# Create NAT gateway

resource "aws_nat_gateway" "wordpress_nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.wordpress_public.id

  tags = {
    Name = "wordpress_nat"
  }
}

# Create Security group

resource "aws_security_group" "wordpress_sg" {
  name = "wordpress_allow_web"
  description = "Allow inbound web traffic"
  vpc_id = aws_vpc.wp_vpc.id

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "All networks allowed"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "All networks allowed"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

    tags = {
    "Name" = "wordpress_sg"
  }
}

resource "aws_security_group" "mysql_sg" {
  name = "mysql_allow_traffic"
  description = "Allow all trafic"
  vpc_id = aws_vpc.wp_vpc.id
 
  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "All networks allowed"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "All networks allowed"
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

      tags = {
    "Name" = "mysql_sg"
  }
}

# Create interfaces 

resource "aws_network_interface" "mysql_interface" {
  subnet_id       = aws_subnet.MySQL_private.id
  private_ips     = ["10.88.2.10"]
  security_groups = [aws_security_group.mysql_sg.id]

}

resource "aws_network_interface" "wp_interface" {
  subnet_id       = aws_subnet.wordpress_public.id
  private_ips     = ["10.88.1.10"]
  security_groups = [aws_security_group.wordpress_sg.id]
}

resource "aws_instance" "mysql_instance" {
  ami               = "ami-09e67e426f25ce0d7"
  instance_type     = "t2.micro"
  key_name          = "donia-keys"

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo docker run -itd -e MYSQL_ROOT_PASSWORD=wordpress -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress -v wordpress_db:/var/lib/mysql -p 3306:3306 mysql
                
                
                EOF

  tags = {
    Name = "MySQL_instance"
  }

  network_interface {
    network_interface_id = aws_network_interface.mysql_interface.id
    device_index         = 0
  }
}

# Create wordpress instance 

resource "aws_instance" "wordpress_instance" {
  ami               = "ami-09e67e426f25ce0d7"
  instance_type     = "t2.micro"
  key_name          = "donia-keys"

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install docker.io -y
                sudo docker run -itd -e WORDPRESS_DB_HOST=10.88.2.10 -e WORDPRESS_DB_USER=wordpress -e WORDPRESS_DB_PASSWORD=wordpress -e WORDPRESS_DB_NAME=wordpress -v wp_site:/var/www/html -p 80:80 wordpress
                
                
                EOF

  tags = {
    Name = "wordpress_instance"
  }

  network_interface {
    network_interface_id = aws_network_interface.wp_interface.id
    device_index         = 0
  }
}
