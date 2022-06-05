resource "aws_ecs_cluster" "checkout-test-cluster" {
  name               = var.ecs_cluster_name
  tags = {
    "Name" = "ecs-cluster-checkout-test"
  }
}


resource "aws_ecs_task_definition" "ecs-task-checkout" {
  family                   = "ecs-checkout-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<EOF
[
  {
    "name": "checkout-test-container",
    "image": "557707468855.dkr.ecr.us-east-1.amazonaws.com/checkout-test-repo:latest",
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
}

resource "aws_ecs_service" "ecs_service_checkout" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.checkout-test-cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-checkout.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  
  network_configuration {
   security_groups  = [aws_security_group.ec2-sg.id]
   subnets          = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
   assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    container_name   = "checkout-test-container"
    container_port   = 80
  }
  depends_on = [aws_alb_listener.frontend, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_cloudwatch_log_group" "cwlog" {
  name = "/ecs/checkout-test-container"
  tags = {
    "Name" = "checkout-test-container-log"
  }
}

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.checkout-test-cluster.name}/${aws_ecs_service.ecs_service_checkout.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 4
}