module "networking" {
  source            = "../../modules/networking"
  project_name      = var.project_name
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

module "compute" {
  source          = "../../modules/compute"
  project_name    = var.project_name
  ami_id          = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  vpc_id          = module.networking.vpc_id
  subnet_id       = module.networking.subnet_id
}

# The aws_key_pair resource has been removed since the key pair already exists