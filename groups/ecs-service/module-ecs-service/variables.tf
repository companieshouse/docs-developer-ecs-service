# ------------------------------------------------------------------------------
# Environmental configuration
# ------------------------------------------------------------------------------
variable "environment" {
  type        = string
  description = "The environment name, defined in envrionments vars."
}
variable "aws_region" {
  default     = "eu-west-2"
  type        = string
  description = "The AWS region for deployment."
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in use for the ECS cluster and associated resources e.g. ALBs."
}
variable "ecs_cluster_id" {
  type        = string
  description = "The ID of the ECS cluster the ECS service will be created in."
}
variable "task_execution_role_arn" {
  type        = string
  description = "The ARN of the IAM role to use to execute the ECS service tasks."
}

# ------------------------------------------------------------------------------
# Docker container details
# ------------------------------------------------------------------------------
variable "docker_registry" {
  type        = string
  description = "The FQDN of the docker registry."
}
variable "docker_repo" {
  type        = string
  description = "The repository to use with in the given docker registry."
}
variable "container_version" {
  type        = string
  description = "The version of the docker container to run."
}
variable "container_port" {
  type        = string
  description = "The port the container exposes. This must match the port used by the service in its environment variables."
}

# ------------------------------------------------------------------------------
# Service configuration
# ------------------------------------------------------------------------------
variable "service_name" {
  type        = string
  description = "The user friendly service name used to name AWS resources."
}
variable "name_prefix" {
  type        = string
  description = "The user friendly name prefix used to name AWS resources."
}

# ------------------------------------------------------------------------------
# Service performance and scaling configs
# ------------------------------------------------------------------------------
variable "desired_task_count" {
  type = number
  description = "The desired ECS task count for this service"
  default = 1
}
variable "required_cpus" {
  type = number
  description = "The required cpu count for this service"
  default = 1
}
variable "required_memory" {
  type = number
  description = "The required memory for this service"
  default = 512
}

# ------------------------------------------------------------------------------
# Service environment variable and secret configs
# ------------------------------------------------------------------------------
variable "task_environment" {
  type        = list
  description = "The environment variables required by the service to be included in the task definition"
}
variable "task_secrets" {
  type        = list
  description = "The secrets required by the service to be included in the task definition. The values must be Parameter Store Secret ARNs not plaintext."
}

# ------------------------------------------------------------------------------
# Load balancer configuration
# ------------------------------------------------------------------------------
variable "lb_listener_arn" {
  type        = string
  description = "The ARN of the load balancer the ECS service will sit behind."
}
variable "lb_listener_rule_priority" {
  type        = number
  description = "The priority to use when attaching the services listener rules to the load balancer."
}
variable "lb_listener_paths" {
  type        = list(string)
  description = "The path regex patterns that this service controls. Traffic to the load balancer will only be sent to this ECS service if it matches one of these defined path patterns."
}
variable "healthcheck_path" {
  type        = string
  description = "The path to use to perform service healthchecks."
  default = "/"
}
variable "healthcheck_matcher" {
  type        = string
  description = "The expected response code to pass service healthchecks."
  default = "200"
}
variable "healthcheck_healthy_threshold" {
  type        = string
  description = "The number of healthchecks required to become healthy."
  default = "5"
}
variable "healthcheck_unhealthy_threshold" {
  type        = string
  description = "The number of healthchecks required to become unhealthy."
  default = "2"
}
variable "healthcheck_interval" {
  type        = string
  description = "The interval between service healthchecks."
  default = "30"
}
