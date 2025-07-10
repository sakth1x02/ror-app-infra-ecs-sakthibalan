variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
}

variable "secrets_map" {
  description = "Map of secrets to store in Secrets Manager"
  type        = map(string)
}

variable "iam_role_name" {
  description = "Name for the IAM role"
  type        = string
}

variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}

variable "rails_app_container_name" {
  description = "Container name for rails_app"
  type        = string
  default     = "rails_app"
}

variable "webserver_container_name" {
  description = "Container name for webserver"
  type        = string
  default     = "webserver"
}

variable "rails_app_port" {
  description = "Container port for rails_app"
  type        = number
  default     = 3000
}

variable "webserver_port" {
  description = "Container port for webserver"
  type        = number
  default     = 80
}

variable "ecs_name" {
  description = "Name for the ECS cluster/service"
  type        = string
}

variable "cpu" {
  description = "CPU units for ECS task"
  type        = number
}

variable "memory" {
  description = "Memory (MB) for ECS task"
  type        = number
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
}

variable "environment" {
  description = "List of environment variables for ECS"
  type        = list(object({ name = string, value = string }))
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "rds_name" {
  description = "Name for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "db_engine_version" {
  description = "Postgres engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS"
  type        = number
}

variable "db_multi_az" {
  description = "Enable Multi-AZ for RDS"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "health_check_path" {
  description = "Health check path for the ALB"
  type        = string
  default     = "/"
}

variable "container_port" {
  description = "Port for the ALB target group (should match webserver_port)"
  type        = number
  default     = 80
} 