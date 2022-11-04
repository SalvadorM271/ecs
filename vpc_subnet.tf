// vpc and internet gateway, one igw is enough for the two availability zone

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
  }
}

// subnets, creates a public and private subnet for each availability zone

module "public_subnet_1" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.availability_zone[0]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
}

module "public_subnet_2" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.availability_zone[1]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[0]
}

module "private_subnet_1" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[2]
    availability_zone = var.availability_zone[0]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
}

module "private_subnet_2" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.main.id
    subnet_cidr_block = var.subnet_cidr_block[3]
    availability_zone = var.availability_zone[1]
    environment = var.environment
    map_public_ip_on_launch = var.map_public_ip_on_launch[1]
}