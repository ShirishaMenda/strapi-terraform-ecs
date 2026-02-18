# Deployed Strapi on AWS ECS (EC2) using Terraform & GitHub Actions


# Prerequisites

Before starting, ensure the following are available:

AWS Account (Region: us-east-1 only)

IAM Role provided

Role Name: ec2-ecr-role

Role ARN: arn:aws:iam::811738710312:role/ec2-ecr-role

Instance Profile ARN: arn:aws:iam::811738710312:instance-profile/ec2-ecr-role

GitHub repository

AWS Access Key & Secret added to GitHub Secrets

Docker & Node.js installed locally


# Step 1: Create Strapi Application

mkdir strapi-ecs
cd strapi-ecs
npx create-strapi-app . --quickstart



# Step 2: Configure Database for PostgreSQL (RDS)

Strapi v4 uses TypeScript config.

Edit file:

config/database.ts


Update it to use environment variables:

export default ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME'),
      user: env('DATABASE_USERNAME'),
      password: env('DATABASE_PASSWORD'),
      ssl: false,
    },
  },
});



Allows Strapi to connect to AWS RDS



# Step 3: Create Dockerfile

Create a file named Dockerfile in project root.

The Dockerfile builds the app, installs dependencies, and exposes port 1337.



# Step 4: Create Terraform Folder Structure

Create Terraform directory:

mkdir terraform


That Terraform manages

ECR Repository

ECS Cluster (EC2)

ECS Task Definition

ECS Service

EC2 Instance

RDS PostgreSQL

Security Groups

IAM role attachment

All infrastructure is created only via Terraform.



# Step 5: Create GitHub Actions Workflow

Workflow does the following on every push to main:

Checkout source code

Configure AWS credentials

Run Terraform init & apply

Create ECR repository (if not exists)

Login to ECR

Build Docker image

Tag image as latest

Push image to ECR

Re-apply Terraform to update ECS task revision



# Step 6: Push Code to GitHub
git init
git add .
git commit -m "Deploy Strapi on ECS EC2 using Terraform"
git branch -M main
git push origin main



# Step 7: Verify ECS & EC2

In AWS Console:

ECS Cluster → Service → Task should be RUNNING

EC2 instance should be healthy

RDS instance should be available

Ensure EC2 security group allows:

Inbound: TCP 1337 from 0.0.0.0/0



# Step 8: Access Strapi Admin Page

Get EC2 Public IP and open browser:

http://<EC2_PUBLIC_IP>:1337/admin