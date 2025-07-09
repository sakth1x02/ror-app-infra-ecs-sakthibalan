# Mallow Infrastructure Project

This repository contains Terraform infrastructure code for deploying a Ruby on Rails application on AWS using ECS, RDS, S3, and other AWS services. The project is organized into two main directories, each with its own specialized infrastructure components.

---

## Project Overview

This project provides a complete infrastructure solution for a Ruby on Rails application, including:
- **CI/CD Pipeline**: Automated Docker image builds and ECR management
- **Application Infrastructure**: Production-ready ECS cluster with RDS, S3, and ALB
- **Security**: IAM roles, Secrets Manager, and private subnets
- **Scalability**: Multi-AZ deployment with load balancing

---

## Directory Structure

```
mallow-main/
├── ror-app-infra-ecs-sakthibalan/
│   └── ROR_infra/
│       ├── ecr_terraform/          # CI/CD Infrastructure
│       │   ├── README.md           # Detailed documentation for ECR/CodeBuild setup
│       │   ├── main.tf
│       │   ├── ecr.tf
│       │   ├── codebuild.tf
│       │   ├── iam.tf
│       │   └── ...
│       └── ecr_hostimg/            # Application Infrastructure
│           ├── README.md           # Detailed documentation for ECS/RDS/S3 setup
│           ├── main.tf
│           ├── modules/
│           │   ├── vpc/
│           │   ├── ecs/
│           │   ├── rds/
│           │   └── ...
│           └── ...
└── README.md                       # This file
```

**Note**: Each directory contains its own comprehensive README.md file with detailed documentation, architecture diagrams, and deployment instructions.

---

## Configuration

Before deploying the infrastructure, you must configure the `terraform.tfvars` files in both directories with your environment-specific values.

### ECR Terraform Configuration

Edit `ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_terraform/terraform.tfvars`:
- Set your AWS region
- Configure project name
- Specify ECR repository names
- Update GitHub repository URL
- Set CodeBuild compute type and timeout

### Application Infrastructure Configuration

Edit `ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_hostimg/terraform.tfvars`:
- Configure VPC and subnet CIDR blocks
- Set database credentials and configuration
- Specify S3 bucket name
- Configure ECS task parameters
- Set environment-specific tags

**Important**: Never commit sensitive values to version control. Use AWS Secrets Manager for all sensitive data.

---

## Deployment Process

The infrastructure deployment follows a sequential approach to ensure proper resource dependencies and configuration.

### Step 1: Deploy CI/CD Infrastructure

```bash
#!/bin/bash
# deploy-cicd.sh

echo "Deploying CI/CD Infrastructure..."
cd ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_terraform

terraform init
terraform plan
terraform apply -auto-approve

echo "CI/CD Infrastructure deployment completed."
```

### Step 2: Deploy Application Infrastructure

```bash
#!/bin/bash
# deploy-app.sh

echo "Deploying Application Infrastructure..."
cd ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_hostimg

terraform init
terraform plan
terraform apply -auto-approve

echo "Application Infrastructure deployment completed."
```

### Complete Deployment

```bash
#!/bin/bash
# deploy-complete.sh

echo "Starting complete infrastructure deployment..."

# Deploy CI/CD infrastructure
echo "Deploying CI/CD Infrastructure..."
cd ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_terraform
terraform init
terraform apply -auto-approve

# Deploy application infrastructure
echo "Deploying Application Infrastructure..."
cd ../ecr_hostimg
terraform init
terraform apply -auto-approve

echo "Complete infrastructure deployment finished successfully."
```

---

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform (v1.0+) installed
- Docker (for local testing)
- GitHub repository with Rails application code

---

## Quick Start

1. Clone this repository
2. Configure AWS credentials
3. Modify terraform.tfvars files in both directories
4. Deploy CI/CD infrastructure first
5. Deploy application infrastructure
6. Follow the detailed documentation in each directory's README.md

---

## Documentation

- **[ECR Terraform README](ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_terraform/README.md)**: CI/CD pipeline documentation
- **[ECR Hostimg README](ror-app-infra-ecs-sakthibalan/ROR_infra/ecr_hostimg/README.md)**: Application infrastructure documentation

---

## License

MIT or your company license here.
