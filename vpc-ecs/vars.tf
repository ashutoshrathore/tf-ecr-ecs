variable "AWS_ACCESS_KEY"{}
variable "AWS_SECRET_KEY"{}

variable "ecr" {
    description = "Name of ecr repo"
    type    = string
    default = "checkout-test-repo"
}