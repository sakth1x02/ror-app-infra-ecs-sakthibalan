# Rails App CI/CD with AWS ECR & CodeBuild

This project provides a production-ready, minimalist CI/CD pipeline for a Rails application using AWS ECR (Elastic Container Registry) and AWS CodeBuild, managed via Terraform.

---

## Architecture Diagram

```
flowchart TD
    A[GitHub Repo: Rails App] -->|Push/PR| B[CodeBuild Project]
    B --> C[Docker Build]
    C --> D[ECR: rails_app]
    C --> E[ECR: webserver]
    D -.-> F[Deployment Target (ECS, EC2, etc.)]
    E -.-> F
```

---

## Setup & Prerequisites

- AWS Account with permissions for ECR, CodeBuild, IAM
- GitHub repository for your Rails app
- [Terraform](https://www.terraform.io/) installed
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured

---

## Directory Structure

```
repo-root/
├── docker/
│   ├── app/
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   └── nginx/
│       ├── Dockerfile
│       └── default.conf
├── buildspec.yml
├── ... (Rails app files)

infra/
├── main.tf
├── providers.tf
├── ecr.tf
├── iam.tf
├── codebuild.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

## Deployment Process

1. **Clone your Rails app repo and ensure `buildspec.yml` is at the root.**
2. **Configure Terraform:**
   - Edit `terraform.tfvars` with your AWS region, repo names, and GitHub repo URL.
3. **Deploy Infrastructure:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. **Trigger Build:**
   - Go to AWS Console → CodeBuild → Your Project → Click **Start build**
   - The build will:
     - Log in to ECR
     - Build Docker images for Rails app and webserver
     - Tag and push images to ECR

---

## Configuration Details

- **ECR Repositories:**
  - `rails_app` (for Rails app image)
  - `webserver` (for Nginx image)
- **CodeBuild Project:**
  - Uses `buildspec.yml` from repo root
  - Builds and pushes both images
- **IAM Roles:**
  - Minimal permissions for CodeBuild to access ECR and CloudWatch Logs
- **Variables:**
  - `aws_region`, `project_name`, `ecr_rails_repository_name`, `ecr_webserver_repository_name`, `github_repository_url`, `codebuild_compute_type`, `codebuild_timeout`

---

## Example buildspec.yml

```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - RAILS_REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/rails_app
      - WEBSERVER_REPO_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/webserver
  build:
    commands:
      - echo Building Rails app image...
      - docker build -f docker/app/Dockerfile -t rails_app:$IMAGE_TAG .
      - docker tag rails_app:$IMAGE_TAG $RAILS_REPO_URI:$IMAGE_TAG
      - docker tag rails_app:$IMAGE_TAG $RAILS_REPO_URI:latest
      - echo Building webserver image...
      - docker build -f docker/nginx/Dockerfile -t webserver:$IMAGE_TAG .
      - docker tag webserver:$IMAGE_TAG $WEBSERVER_REPO_URI:$IMAGE_TAG
      - docker tag webserver:$IMAGE_TAG $WEBSERVER_REPO_URI:latest
  post_build:
    commands:
      - echo Pushing Rails app image...
      - docker push $RAILS_REPO_URI:$IMAGE_TAG
      - docker push $RAILS_REPO_URI:latest
      - echo Pushing webserver image...
      - docker push $WEBSERVER_REPO_URI:$IMAGE_TAG
      - docker push $WEBSERVER_REPO_URI:latest
      - echo Build completed on `date`
```

---

## Notes
- You can further automate builds by adding a CodeBuild webhook for GitHub push events.
- For production, use secure IAM policies and rotate credentials regularly.
- To deploy images, integrate with ECS, EC2, or other AWS services as needed.

---

## License
MIT 