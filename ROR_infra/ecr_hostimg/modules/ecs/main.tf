resource "aws_ecs_cluster" "this" {
  name = var.name
  tags = var.tags
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Allow inbound from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.webserver_port
    to_port         = var.webserver_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = var.rails_app_container_name
      image     = var.rails_app_image
      portMappings = [{ containerPort = var.rails_app_port }]
      environment = var.environment
      secrets = [
        for s in var.secrets : {
          name      = s.name
          valueFrom = s.value_from
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
    {
      name      = var.webserver_container_name
      image     = var.webserver_image
      portMappings = [{ containerPort = var.webserver_port }]
      dependsOn = [{ containerName = var.rails_app_container_name, condition = "START" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.name}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = var.name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.webserver_container_name
    container_port   = var.webserver_port
  }
  depends_on = [aws_ecs_task_definition.this]
  tags       = var.tags
} 