# Create ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

# Create Task Definition
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = "${aws_ecr_repository.strapi_repo.repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 1337
        protocol      = "tcp"
      }]

      environment = [
        {
          name  = "DATABASE_HOST"
          value = aws_db_instance.strapi_db.address
        },
        {
          name  = "DATABASE_PORT"
          value = "5432"
        },
        {
          name  = "DATABASE_NAME"
          value = "strapidb"
        },
        {
          name  = "DATABASE_USERNAME"
          value = "strapiuser"
        },
        {
          name  = "DATABASE_PASSWORD"
          value = "StrapiPass123"
        }
      ]
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  force_new_deployment = true

  depends_on = [
    aws_ecs_cluster.strapi_cluster,
    aws_ecs_task_definition.strapi_task
  ]

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
