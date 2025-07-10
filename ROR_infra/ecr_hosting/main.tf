module "vpc" {
  source              = "./modules/vpc"
  name                = var.vpc_name
  cidr_block          = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs= var.private_subnet_cidrs
  azs                 = var.azs
  tags                = var.tags
}

module "s3" {
  source = "./modules/s3"
  name   = var.s3_bucket_name
  tags   = var.tags
}

resource "random_pet" "secrets_suffix" {
  length = 2
}

locals {
  secrets_name = "mallow-prod-app-secrets-${random_pet.secrets_suffix.id}"
  rails_app_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/rails_app:latest"
  webserver_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/webserver:latest"
}

module "secrets_manager" {
  source  = "./modules/secrets_manager"
  name    = local.secrets_name
  secrets = var.secrets_map
  tags    = var.tags
}

module "iam" {
  source        = "./modules/iam"
  name          = var.iam_role_name
  secrets_arn   = module.secrets_manager.secret_arn
  s3_bucket_arn = module.s3.arn
  tags          = var.tags
}

module "alb" {
  source            = "./modules/alb"
  name              = var.alb_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_port       = var.webserver_port
  health_check_path = var.health_check_path
  tags              = var.tags
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "ecs" {
  source                = "./modules/ecs"
  name                  = var.ecs_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  execution_role_arn    = module.iam.role_arn
  rails_app_image       = local.rails_app_image
  webserver_image       = local.webserver_image
  rails_app_container_name = var.rails_app_container_name
  webserver_container_name = var.webserver_container_name
  rails_app_port        = var.rails_app_port
  webserver_port        = var.webserver_port
  cpu                   = var.cpu
  memory                = var.memory
  desired_count         = var.desired_count
  environment           = var.environment
  secrets = [
    { name = "RDS_DB_NAME",     value_from = "${module.secrets_manager.secret_arn}:RDS_DB_NAME" },
    { name = "RDS_USERNAME",    value_from = "${module.secrets_manager.secret_arn}:RDS_USERNAME" },
    { name = "RDS_PASSWORD",    value_from = "${module.secrets_manager.secret_arn}:RDS_PASSWORD" },
    { name = "RDS_HOSTNAME",    value_from = "${module.secrets_manager.secret_arn}:RDS_HOSTNAME" },
    { name = "RDS_PORT",        value_from = "${module.secrets_manager.secret_arn}:RDS_PORT" },
    { name = "S3_BUCKET_NAME",  value_from = "${module.secrets_manager.secret_arn}:S3_BUCKET_NAME" },
    { name = "S3_REGION_NAME",  value_from = "${module.secrets_manager.secret_arn}:S3_REGION_NAME" },
    { name = "LB_ENDPOINT",     value_from = "${module.secrets_manager.secret_arn}:LB_ENDPOINT" }
  ]
  aws_region            = var.aws_region
  target_group_arn      = module.alb.target_group_arn
  tags                  = var.tags
  depends_on            = [module.secrets_manager]
}

module "rds" {
  source                = "./modules/rds"
  name                  = var.rds_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.ecs.security_group_id
  db_username           = var.db_username
  db_password           = var.db_password
  db_name               = var.db_name
  port                  = var.db_port
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  allocated_storage     = var.db_allocated_storage
  multi_az              = var.db_multi_az
  tags                  = var.tags
} 