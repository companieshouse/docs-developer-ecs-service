resource "aws_ecs_service" "ecs-service" {
  name            = "${var.environment}-${var.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ecs-task-definition.arn
  desired_count   = var.desired_task_count
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
    container_port   = var.container_port
    container_name   = var.service_name
  }
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                = "${var.environment}-${var.service_name}"
  execution_role_arn    = var.task_execution_role_arn
  container_definitions    = <<DEFINITION
    [
        {
            "environment": ${jsonencode(var.task_environment)},
            "name": "${var.service_name}",
            "image": "${var.docker_registry}/${var.docker_repo}:${var.container_version}",
            "cpu": ${var.required_cpus},
            "memory": ${var.required_memory},
            "mountPoints": [],
            "portMappings": [{
                "containerPort": ${var.container_port},
                "hostPort": 0,
                "protocol": "tcp"
            }],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-create-group": "true",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-group": "/ecs/${var.name_prefix}/${var.service_name}",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "secrets": ${jsonencode(var.task_secrets)},
            "volumesFrom": [],
            "essential": true
        }
    ]
  DEFINITION
}

resource "aws_lb_target_group" "ecs-target-group" {
  name     = "${var.environment}-${var.service_name}"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.healthcheck_healthy_threshold
    unhealthy_threshold = var.healthcheck_unhealthy_threshold
    interval            = var.healthcheck_interval
    matcher             = var.healthcheck_matcher
    path                = var.healthcheck_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "lb-listener-rule" {
  listener_arn = var.lb_listener_arn
  priority     = var.lb_listener_rule_priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
  }
  condition {
    path_pattern {
      values = var.lb_listener_paths
    }
  }
}
