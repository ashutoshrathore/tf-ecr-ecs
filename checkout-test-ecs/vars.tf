variable "AWS_ACCESS_KEY"{}
variable "AWS_SECRET_KEY"{}

variable "ecs_cluster_name" {
    description = "Name of ECS Cluster"
    type    = string
    default = "ecs-checkout-cluster"
}

variable "ecs_task_definition_name" {
    description = "Name of ecs task defination"
    type    = string
    default = "ecs-checkout-task"
}

variable "ecs_service_name" {
    description = "Name of ecs service"
    type    = string
    default = "ecs-checkout-service"
}

variable "key_name" {
    description = "The name for ssh key, used for aws_launch_configuration"
    type    = string
    default = "ecs_checkout_launch"
}

variable "pub_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "pub_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "pvt_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "pvt_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "http_port" {
    description = "this needs to be secured, and should not be use 80, but using here for demo purpose"
    default     = 80
}