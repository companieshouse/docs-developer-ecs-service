resource "aws_ecs_service" "docs-developer-ecs-service" {
  name            = "${var.environment}-${local.service_name}"
  cluster         = local.ecs_cluster_id
  task_definition = aws_ecs_task_definition.docs-developer-task-definition.arn
  desired_count   = var.desired_task_count
  load_balancer {
    target_group_arn = aws_lb_target_group.docs-developer-target_group.arn
    container_port   = local.docs_developer_port
    container_name   = "docs-developer"
  }
}

resource "aws_ecs_task_definition" "docs-developer-task-definition" {
  family                = "${var.environment}-${local.service_name}"
  execution_role_arn    = local.task_execution_role_arn
  container_definitions    = <<DEFINITION
    [
        {
            "environment": ${jsonencode(local.task_environment)},
            "name": "${local.service_name}",
            "image": "${var.docker_registry}/local/docs.developer.ch.gov.uk:${var.docs_developer_version}",
            "cpu": ${var.required_cpus},
            "memory": ${var.required_memory},
            "mountPoints": [],
            "portMappings": [{
                "containerPort": ${local.docs_developer_port},
                "hostPort": 0,
                "protocol": "tcp"
            }],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-group": "/ecs/${local.name_prefix}/${local.service_name}",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "secrets": ${jsonencode(local.task_secrets)},
            "volumesFrom": [],
            "essential": true
        }
    ]
  DEFINITION
}

resource "aws_lb_target_group" "docs-developer-target_group" {
  name     = "${var.environment}-${local.service_name}"
  port     = local.docs_developer_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "docs-developer" {
  listener_arn = local.dev_site_lb_listener_arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docs-developer-target_group.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
