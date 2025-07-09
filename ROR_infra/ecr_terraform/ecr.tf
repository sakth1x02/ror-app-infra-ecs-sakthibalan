# ECR Repositories
resource "aws_ecr_repository" "rails_app" {
  name                 = var.ecr_rails_repository_name
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository" "webserver" {
  name                 = var.ecr_webserver_repository_name
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  encryption_configuration {
    encryption_type = "AES256"
  }
} 