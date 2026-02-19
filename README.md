# Deploy Strapi on AWS ECS Fargate using Terraform & GitHub Actions


# The workflow consists of:

Creating a Strapi application

Writing Terraform configuration for AWS infrastructure

Deploying infrastructure with Terraform

Pushing code to GitHub to trigger CI/CD

GitHub Actions builds the Strapi Docker image

GitHub Actions pushes the image to Amazon ECR

GitHub Actions updates the ECS task definition

ECS Fargate deploys the new revision automatically



# 1. Create the Strapi Application

npx create-strapi-app@latest my-strapi-app


# 2. Prepare Terraform Configuration

Terraform is used to create:

VPC with public and private subnets,NAT Gateway

Security groups

ECS Cluster

ECS Task Definition (Fargate)

ECS Service with Load Balancer

IAM Roles required for ECS + GitHub Actions

Amazon RDS PostgreSQL

Amazon ECR Repository

ALB Target Group + Listener

Strapi uses RDS PostgreSQL as its main database.

You will store:

Terraform files

Dockerfile

GitHub Actions workflow

Task Definition template

Inside your repository.



# 3. Configure GitHub Secrets

The CI/CD pipeline requires AWS credentials and environment configuration.

Create these keys:

Secret Key	Description
AWS_ACCESS_KEY_ID	IAM access key for GitHub Actions
AWS_SECRET_ACCESS_KEY	IAM secret key
AWS_REGION	Set to us-east-1
ECR_REPOSITORY	Name of your ECR repo
CLUSTER_NAME	Your ECS cluster name
SERVICE_NAME	Your ECS service name



# 4. Initialize Terraform (Locally)

Before GitHub Actions can deploy Strapi, AWS infrastructure must already exist.

Run these commands inside the Terraform folder:

terraform init
terraform validate
terraform plan



# 5. Deploy AWS Infrastructure Using Terraform

Apply infrastructure the first time locally:

terraform apply -auto-approve


This will:

Create networking

Create RDS PostgreSQL

Create ECR repository

Create IAM roles

Create ECS cluster/service

Create ALB

Create and register the initial ECS task definition

Once done, your AWS environment is live and ready to receive the Strapi container image.


# 6. Push Code to GitHub to Trigger CI/CD

After Terraform is applied:

git init
git add .
git commit -m "Initial Strapi AWS Deployment"
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main


Pushing the code triggers the GitHub Actions workflow.


# 7. How the GitHub Actions Workflow Works

Your workflow:

Logs in to Amazon ECR

Builds the Strapi Docker image

Tags the image using:

latest

Git commit SHA

Pushes image to ECR

Generates a new ECS task definition with the updated image tag

Registers the new task definition revision

Forces a new ECS deployment using:

updated image

same environment variables

Waits for service stabilization

This automates your entire deployment pipeline.



# 8. Access Your Strapi Application

After deployment, the workflow outputs:

Load Balancer DNS

ECS service status

Open the ALB DNS name in a browser to access Strapi.



# 9. Future Deployments

Once infrastructure is created:

You never run Terraform manually again

You simply push code changes

GitHub Actions will:

Rebuild the Docker image

Push the image to ECR

Deploy the new version to ECS

This forms a complete CI/CD pipeline.
