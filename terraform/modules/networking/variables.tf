variable "project_name" {
  type = string
  description = "Name of the project"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR block for the VPC"
}

variable "subnet_cidr" {
  type = string
  description = "CIDR block for the public subnet"
}

variable "availability_zone" {
  type = string
  description = "Availability Zone for the public subnet"
}