resource "aws_vpc" "rag_cs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "rag_cs_subnet" {
  vpc_id                  = aws_vpc.rag_cs_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-subnet"
  }
}

resource "aws_internet_gateway" "rag_cs_igw" {
  vpc_id = aws_vpc.rag_cs_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "rag_cs_rt" {
  vpc_id = aws_vpc.rag_cs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rag_cs_igw.id
  }
  tags = {
    Name = "${var.project_name}-rt"
  }
}

resource "aws_route_table_association" "rag_cs_rta" {
  subnet_id      = aws_subnet.rag_cs_subnet.id
  route_table_id = aws_route_table.rag_cs_rt.id
}