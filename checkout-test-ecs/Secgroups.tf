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


resource "aws_security_group" "ec2-sg" {
  description = "security-group-ec2"
  name = "security-group-ec2"
  vpc_id = aws_vpc.vpc_checkout_ecs.id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    to_port         = 80
  }

  tags = {
    Name = "security-group-ec2"
  }
  depends_on    = [aws_security_group.alb_sg]
}