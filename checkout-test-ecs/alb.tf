resource "aws_security_group" "alb_sg" {
  description = "security-group-alb"
  name = "security-group-alb"
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
  tags = {
    Name = "security-group-alb"
  }

}

resource "aws_lb" "alb-ecs" {
  name            = "alb-ecs-public"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = aws_subnet.public_subnet_a.id

}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 8080
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
    }

  stickiness {
    type = "lb_cookie"
  }

}

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.alb-ecs.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

