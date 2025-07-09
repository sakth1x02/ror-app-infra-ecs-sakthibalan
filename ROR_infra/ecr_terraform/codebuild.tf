locals {
  buildspec_content = file("${path.module}/scripts/buildspec.yml")
  buildspec_hash    = sha1(local.buildspec_content)
}

# CodeBuild Project
resource "aws_codebuild_project" "build" {
  name          = "${var.project_name}-build"
  description   = "Build Rails app and webserver Docker images"
  build_timeout = var.codebuild_timeout
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    
    environment_variable {
      name  = "RAILS_REPO"
      value = aws_ecr_repository.rails_app.name
    }
    
    environment_variable {
      name  = "WEBSERVER_REPO"
      value = aws_ecr_repository.webserver.name
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repository_url
    git_clone_depth = 1
    # No buildspec argument: use buildspec.yml from repo root
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-build"
      stream_name = "build-log"
    }
  }
} 