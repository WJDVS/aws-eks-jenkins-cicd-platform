# VPC Definition matching our manual architecture (ekscicd-vpc)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ekscicd-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ekscicd-vpc-igw"
  }
}

# Public Subnet 1 (us-east-1a)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "ekscicd-vpc-subnet-public1-us-east-1a"
    "kubernetes.io/role/elb" = "1"
  }
}

# Public Subnet 2 (us-east-1b)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "ekscicd-vpc-subnet-public2-us-east-1b"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnet 1 (us-east-1a)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ekscicd-vpc-subnet-private1-us-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Private Subnet 2 (us-east-1b)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"

  tags = {
    Name = "ekscicd-vpc-subnet-private2-us-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
