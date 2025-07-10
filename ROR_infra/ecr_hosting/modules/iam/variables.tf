variable "name" {
  description = "Name for the IAM role"
  type        = string
}

variable "secrets_arn" {
  description = "ARN of the Secrets Manager secret"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
} 