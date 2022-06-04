
resource "aws_ecr_repository" "repo-checkout-test" {
  name = var.ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ECR_REPOSITORY" {
  value = aws_ecr_repository.repo-checkout-test.repository_url
}