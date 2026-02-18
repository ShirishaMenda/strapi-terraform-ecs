resource "aws_ecs_cluster" "cluster" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = "${aws_ecr_repository.repo.repository_url}:latest"

      portMappings = [
        {
          containerPort = 1337
        }
      ]

      environment = [
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  health_check_grace_period_seconds = 60

  depends_on = [aws_lb_listener.listener]
}
