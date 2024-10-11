variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "rag-cs-dev"
}

variable "ami_id" {
  type    = string
  default = "ami-0866a3c8686eaeeba"  # Amazon Linux 2 AMI, update as needed
}

variable "instance_type" {
  type    = string
  default = "t2.xlarge"
}

variable "key_name" {
  type    = string
  default = "ajay"  # This should match the name of your existing key pair in AWS
}

# We can keep this variable in case it's used elsewhere, but it's not needed for the key pair anymore
variable "public_key_path" {
  type    = string
  default = "C:/Users/alexi/.ssh/ajay.pem"
}