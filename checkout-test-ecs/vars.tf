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
    description = "Name of ecs service
    type    = string
    default = "ecs-checkout-service"
}

variable "key_name" {
    description = "The name for ssh key, used for aws_launch_configuration"
    type    = string
    default = "ecs_checkout_launch"
}

