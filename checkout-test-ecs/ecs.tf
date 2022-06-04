resource "aws_ecs_cluster" "web-cluster" {
  name               = var.ecs_cluster_name
  capacity_providers = [aws_ecs_capacity_provider.ecs-capacity.name]
  tags = {
    "Name" = "ecs-cluster"
  }
}

resource "aws_ecs_capacity_provider" "ecs-capacity" {
  name = "capacity-provider-ecs"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-asg.arn
    managed_termination_protection = "ENABLED"
    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  family                = var.ecs_task_definition_name
  container_definitions = <<EOF
[
  {
    "name": "checkout-test-container",
    "image": "557707468855.dkr.ecr.us-east-1.amazonaws.com/checkout-test-repo",
    "memory": 1024,
    "cpu": 512,
    "essential": true,
    "entryPoint": ["/"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOF
  network_mode          = "bridge"
  tags = {
    "Name" = "checkout-container"
  }
}

resource "aws_ecs_service" "ecs_service_checkout" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-definition.arn
  desired_count   = 3
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "checkout-test-container"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
  depends_on  = [aws_lb_listener.web-listener]
}

resource "aws_cloudwatch_log_group" "cwlog" {
  name = "/ecs/checkout-test-container"
  tags = {
    "Name" = "checkout-test-container-log"
  }
}

