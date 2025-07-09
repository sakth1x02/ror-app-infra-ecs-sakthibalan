variable "name" {
  description = "Name for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 3000
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 