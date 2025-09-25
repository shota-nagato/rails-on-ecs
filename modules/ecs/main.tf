resource "aws_ecs_cluster" "main" {
  name = "${var.common.prefix}-${var.common.environment}-ecs-cluster"
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${var.common.prefix}-${var.common.environment}-web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "${var.ecr_repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.web.name
          awslogs-region        = var.common.region
          awslogs-stream-prefix = "ecs"
        }
      }
      secrets = [
        {
          name      = "RAILS_MASTER_KEY"
          valueFrom = var.ssm.rails_master_key_name
        },
        {
          name      = "DATABASE_URL"
          valueFrom = var.ssm.database_url_name
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "web" {
  name                               = "${var.common.prefix}-${var.common.environment}-web-service"
  cluster                            = aws_ecs_cluster.main.arn
  task_definition                    = aws_ecs_task_definition.web.arn
  launch_type                        = "FARGATE"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = var.network.private_esc_subnet_ids
    security_groups  = [var.network.security_group_ecs_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb.alb_target_group_arn
    container_name   = "web"
    container_port   = 3000
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.common.prefix}-${var.common.environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_for_task_execution_role.json
}

data "aws_iam_policy_document" "trust_policy_for_task_execution_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec_task_execution" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_read" {
  role = aws_iam_role.task_execution_role.name
  # TODO: 最小権限にする
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.common.prefix}-${var.common.environment}-web"
  retention_in_days = 14

  tags = {
    Name = "/ecs/${var.common.prefix}-${var.common.environment}-web"
  }
}
