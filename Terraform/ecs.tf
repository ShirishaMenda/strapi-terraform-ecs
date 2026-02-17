# Create ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

# Create Task Definition
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = "arn:aws:iam::811738710312:role/ec2-ecr-role"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = "${aws_ecr_repository.strapi_repo.repository_url}:latest"

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
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
  }
}
