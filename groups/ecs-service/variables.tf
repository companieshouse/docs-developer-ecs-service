# ------------------------------------------------------------------------------
# Environment
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
variable "aws_profile" {
  default     = "development-eu-west-2"
  type        = string
  description = "The AWS profile to use for deployment."
}

# ------------------------------------------------------------------------------
# Terraform
# ------------------------------------------------------------------------------
variable "aws_bucket" {
  type        = string
  description = "The bucket used to store the current terraform state files"
}
variable "remote_state_bucket" {
  type        = string
  description = "Alternative bucket used to store the remote state files from ch-service-terraform"
}
variable "state_prefix" {
  type        = string
  description = "The bucket prefix used with the remote_state_bucket files."
}
variable "deploy_to" {
  type        = string
  description = "Bucket namespace used with remote_state_bucket and state_prefix."
}

# ------------------------------------------------------------------------------
# Docker Container
# ------------------------------------------------------------------------------
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
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
# Service environment variable configs
# ------------------------------------------------------------------------------

variable "log_level" {
  default     = "info"
  type        = string
  description = "The log level for services to use: trace, debug, info or error"
}
variable "docs_developer_version" {
  type        = string
  description = "The version of the docs.developer.ch.gov.uk container to run."
}

variable "cdn_host" {
  type        = string
}
variable "chs_url" {
  type        = string
}
variable "account_local_url" {
  type        = string
}
variable "dev_specs_url" {
  type        = string
}
variable "piwik_url" {
  type        = string
}
variable "piwik_site_id" {
  type        = string
}
variable "redirect_uri" {
  type        = string
  default     = "/"
}
variable "cache_pool_size" {
  type        = string
  default     = "8"
}
variable "cache_server" {
  type        = string
}
variable "cookie_domain" {
  type        = string
}
variable "cookie_name" {
  type        = string
  default     = "__SID"
}
variable "cookie_secure_only" {
  type        = string
  default     = "0"
}
variable "default_session_expiration" {
  type        = string
  default     = "3600"
}
variable "oauth2_redirect_uri" {
  type        = string
}
variable "oauth2_auth_uri" {
  type        = string
}
