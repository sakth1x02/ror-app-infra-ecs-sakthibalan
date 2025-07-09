# Main Terraform configuration for Rails ECR and CodeBuild setup
# This file serves as the entry point and references all other modules

# The actual resources are defined in:
# - providers.tf: Terraform and AWS provider configuration
# - ecr.tf: ECR repositories for Rails app and webserver
# - iam.tf: IAM roles and policies for CodeBuild
# - codebuild.tf: CodeBuild project and build trigger

# All resources are automatically created when you run:
# terraform init
# terraform plan
# terraform apply 