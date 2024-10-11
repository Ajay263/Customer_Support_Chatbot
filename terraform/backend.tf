# backend.tf
terraform {
  backend "s3" {
    bucket         = "econet-chatbot-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}



