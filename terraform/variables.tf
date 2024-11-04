variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-north-1"
}

# variable "aws_ecs_task_definitionArn" {
#   description = "arn of existing task revision"
#   type = string
#   default = "arn:aws:ecs:eu-north-1:762233768038:task-definition/aws-node-app-task-family:2"
# }

# variable desired_count {
#   description = "Desired number of containers"
#   type = number
#   default = 1
# }

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "log-blog"
}

variable "cluster_name" {
    description = "ECS cluster name"
    type = string
    default = "otmjka-microservices"
}

variable "service_name" {
    description = "ECS service name"
    type = string
    default = "log-blog-service"
}

variable "task_def_family_name" {
  description = "task_def_family_name"
  type = string
  default = "b-log-app-task-defenition-family"
}

variable "ecs_task_execution_role_arn" {
    description = "role"
    type = string
    default = "arn:aws:iam::762233768038:role/aws-node-app-ecs-task-execution-role"
}

variable "container_name" {
  description = "deploy.yaml CONTAINER_NAME"
  type = string
  default = "b-log-app"
}

variable "container_image" {
  description = "Container image URI"
  type        = string
  default     = "762233768038.dkr.ecr.eu-north-1.amazonaws.com/akjmto/log-blog"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "availability_zones" {
  type = list(string)

  default = [ "eu-north-1a", "eu-north-1b" ]
}

variable "vpc_name" {
  description = "tag name of vpc"
  type = string
  default = "aws-node-app-vpc"
}

variable "alb_name" {
  description = "load balancer"
  type = string
  default = "b-log-app-load-balancer"
}

variable "repo_name" {
  description = "load balancer"
  type = string
  default = "akjmto/log-blog"
}





variable "tg_name" {
  description = "load balancer aws_node_app_lb_target_group"
  type = string
  default = "b-log-app-tg"
}

variable "ecs_task_execution_role_name" {
  description = "load balancer aws_node_app_lb_target_group"
  type = string
  default = "aws-node-app-ecs-task-execution-role"
}

variable "vpc_id" {
  description = "vpc id"
  type = string
  default = "vpc-0d1a39fdda4ead250"
}

variable "subnets" {
  description = "eu-north-1a, eu-north-1b public 2 private 2 subnets list"
  type = list(string)
  default = ["subnet-0bc793deadfe716d9", "subnet-07fc09aebc8ebdecd", "subnet-0063983a820fc6b44", "subnet-0e10f909d7d36af0f"]
}

variable "public_subnets" {
  description = "eu-north-1a, eu-north-1b public 2 subnets list"
  type = list(string)
  default = ["subnet-0bc793deadfe716d9", "subnet-07fc09aebc8ebdecd"]
}

variable "private_subnets" {
  description = "eu-north-1a, eu-north-1b private 2 subnets list"
  type = list(string)
  default = ["subnet-0063983a820fc6b44", "subnet-0e10f909d7d36af0f"]
}



