variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
}

variable "ecr_rails_repository_name" {
  description = "Name of the ECR repository for Rails application"
  type        = string
}

variable "ecr_webserver_repository_name" {
  description = "Name of the ECR repository for Nginx webserver"
  type        = string
}

variable "github_repository_url" {
  description = "GitHub repository URL"
  type        = string
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute type"
  type        = string
}

variable "codebuild_timeout" {
  description = "CodeBuild timeout in minutes"
  type        = number
} 