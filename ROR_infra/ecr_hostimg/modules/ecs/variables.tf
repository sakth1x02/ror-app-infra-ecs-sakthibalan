variable "name" {
  description = "Name for ECS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ECS"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "rails_app_image" {
  description = "ECR image URI for rails_app"
  type        = string
}

variable "webserver_image" {
  description = "ECR image URI for webserver"
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

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Memory (MB) for the task"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 2
}

variable "environment" {
  description = "List of environment variables (map with name/value) for rails_app"
  type        = list(object({ name = string, value = string }))
  default     = []
}

variable "secrets" {
  description = "List of secrets (map with name/value_from) for rails_app"
  type        = list(object({ name = string, value_from = string }))
  default     = []
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for ALB"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 