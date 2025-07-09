output "ecr_rails_repository_url" {
  description = "URL of the Rails application ECR repository"
  value       = aws_ecr_repository.rails_app.repository_url
}

output "ecr_webserver_repository_url" {
  description = "URL of the webserver ECR repository"
  value       = aws_ecr_repository.webserver.repository_url
}



output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.build.name
}

output "docker_login_command" {
  description = "Docker login command for ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

output "manual_build_commands" {
  description = "Manual build and push commands"
  value = {
    login = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    build_rails = "docker build -f docker/app/Dockerfile -t rails_app:latest ."
    build_webserver = "docker build -f docker/nginx/Dockerfile -t webserver:latest ."
    tag_rails = "docker tag rails_app:latest ${aws_ecr_repository.rails_app.repository_url}:latest"
    tag_webserver = "docker tag webserver:latest ${aws_ecr_repository.webserver.repository_url}:latest"
    push_rails = "docker push ${aws_ecr_repository.rails_app.repository_url}:latest"
    push_webserver = "docker push ${aws_ecr_repository.webserver.repository_url}:latest"
  }
} 