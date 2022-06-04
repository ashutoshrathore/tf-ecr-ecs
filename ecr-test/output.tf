
output "ECR_REPOSITORY" {
  value = aws_ecr_repository.repo-checkout-test.repository_url
}