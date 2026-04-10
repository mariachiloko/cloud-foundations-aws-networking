provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "main-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = "public-subnet-az1"
      Tier = "public"
      AZ   = "${var.aws_region}a"
    }
  )
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = merge(
    var.common_tags,
    {
      Name = "public-subnet-az2"
      Tier = "public"
      AZ   = "${var.aws_region}b"
    }
  )
}

resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_app_subnet_az1_cidr
  availability_zone = "${var.aws_region}a"

  tags = merge(
    var.common_tags,
    {
      Name = "private-app-subnet-az1"
      Tier = "private-app"
      AZ   = "${var.aws_region}a"
    }
  )
}

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_app_subnet_az2_cidr
  availability_zone = "${var.aws_region}b"

  tags = merge(
    var.common_tags,
    {
      Name = "private-app-subnet-az2"
      Tier = "private-app"
      AZ   = "${var.aws_region}b"
    }
  )
}

resource "aws_subnet" "private_db_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_db_subnet_az1_cidr
  availability_zone = "${var.aws_region}a"

  tags = merge(
    var.common_tags,
    {
      Name = "private-db-subnet-az1"
      Tier = "private-db"
      AZ   = "${var.aws_region}a"
    }
  )
}

resource "aws_subnet" "private_db_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_db_subnet_az2_cidr
  availability_zone = "${var.aws_region}b"

  tags = merge(
    var.common_tags,
    {
      Name = "private-db-subnet-az2"
      Tier = "private-db"
      AZ   = "${var.aws_region}b"
    }
  )
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    var.common_tags,
    {
      Name = "main-igw"
    }
  )
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "nat-gateway-eip"
    }
  )
}

resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  depends_on = [aws_internet_gateway.main_igw]

  tags = merge(
    var.common_tags,
    {
      Name = "main-nat-gateway"
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "public-route-table"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gateway.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "private-route-table"
    }
  )
}

resource "aws_route_table_association" "public_subnet_az1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = aws_subnet.private_app_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_app_subnet_az2" {
  subnet_id      = aws_subnet.private_app_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_db_subnet_az1" {
  subnet_id      = aws_subnet.private_db_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_db_subnet_az2" {
  subnet_id      = aws_subnet.private_db_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}
