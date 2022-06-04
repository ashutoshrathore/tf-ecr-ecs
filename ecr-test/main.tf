
resource "aws_ecr_repository" "repo-checkout-test" {
  name = var.ecr

  image_scanning_configuration {
    scan_on_push = true
  }
}