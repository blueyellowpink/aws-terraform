resource "aws_vpc" "vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.env_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "${var.env_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_name}-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_name}-public-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "security_group" {
  name        = "${var.env_name}-security-group"
  description = "${var.env_name} security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer_keypair"
  public_key = file(var.identity_file)
}

resource "aws_instance" "server_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu20.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = file("user_data.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "${var.env_name}-node"
  }
}

# resource "aws_instance" "server_node_2" {
#   instance_type          = "t2.micro"
#   ami                    = data.aws_ami.ubuntu20.id
#   key_name               = aws_key_pair.deployer.key_name
#   vpc_security_group_ids = [aws_security_group.security_group.id]
#   subnet_id              = aws_subnet.public_subnet.id
#   user_data              = file("user_data.tpl")

#   root_block_device {
#     volume_size = 10
#   }

#   tags = {
#     Name = "${var.env_name}-node-2"
#   }
# }
