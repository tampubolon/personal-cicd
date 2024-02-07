locals {
  region = "ap-southeast-1"
  default_tags = {
    Owner       = "team-sre"
    ManagedBy   = "terraform"
    TFProject   = "github.com/tampubolon/pintu-infra/eks-vpc"
    Attributes  = "vpc"
    Environment = "test"
  }
}


# Create VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge({
    Name = "EKS-VPC"
    }, local.default_tags
  )
}


# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks_vpc.id


  tags = merge({
    Name = "Main-IGW"
    }, local.default_tags
  )
}


# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    Name = "Public-Subnet-${count.index}"
    }, local.default_tags
  )
}


# Create Private Subnets
resource "aws_subnet" "private" {
  count      = 3
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index + 3)

  tags = merge({
    Name = "Private-Subnet-${count.index}"
    }, local.default_tags
  )
}


# Create Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge({
    Name = "Public-Route-Table"
    }, local.default_tags
  )
}


# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}