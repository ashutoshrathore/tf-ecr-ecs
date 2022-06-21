resource "aws_lb" "alb-ecs" {
  name            = "alb-ecs-public"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id ]

}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }


#  stickiness {
#    type = "lb_cookie"
#  }

}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn = aws_lb.alb-ecs.arn
  port              = 80
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.alb_target_group]
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.id
  }
}

