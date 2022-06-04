output "alb_dns" {
  value = aws_lb.alb-ecs.dns_name
}

output "vpc_id" {
  value = aws_vpc.vpc_checkout_ecs.id
}

