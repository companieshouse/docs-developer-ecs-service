# Define all hardcoded local variable and local variables looked up from data resources
locals {
  stack_name               = "developer-site" # this must match the stack name the service deploys into
  name_prefix              = "${local.stack_name}-${var.environment}"
  service_name             = "docs-developer"
  docs_developer_port      = "8080" #default tomcat port required here until prod docker container is built allowing port change via env var

  vpc_id                    = data.terraform_remote_state.networks.outputs.vpc_id
  dev_site_lb_listener_arn  = data.aws_lb_listener.dev-site-lb-listener.arn
  ecs_cluster_id            = data.aws_ecs_cluster.ecs-cluster.id
  task_execution_role_arn   = data.aws_iam_role.ecs-cluster-iam-role.arn

  # create a map of secret name => secret arn to pass into ecs service module
  # using the trimprefix function to remove the prefixed path from the secret name
  secrets_arn_map = {
    for sec in data.aws_ssm_parameter.secret:
      trimprefix(sec.name, "/${local.name_prefix}/") => sec.arn
  }

  task_secrets = [
    { "name": "CHS_DEVELOPER_CLIENT_ID", "valueFrom": "${local.secrets_arn_map.web-oauth2-client-id}" },
    { "name": "CHS_DEVELOPER_CLIENT_SECRET", "valueFrom": "${local.secrets_arn_map.web-oauth2-client-secret}" },
    { "name": "COOKIE_SECRET", "valueFrom": "${local.secrets_arn_map.web-oauth2-cookie-secret}" },
    { "name": "DEVELOPER_OAUTH2_REQUEST_KEY", "valueFrom": "${local.secrets_arn_map.web-oauth2-request-key}" }
  ]

  task_environment = [
    { "name": "DOC_DEVELOPER_SERVICE_PORT", "value": "${local.docs_developer_port}" },
    { "name": "LOGLEVEL", "value": "${var.log_level}" },
    { "name": "CDN_HOST", "value": "${var.cdn_host}" },
    { "name": "CHS_URL", "value": "${var.chs_url}" },
    { "name": "ACCOUNT_LOCAL_URL", "value": "${var.account_local_url}" },
    { "name": "DEVELOPER_SPECS_URL", "value": "${var.dev_specs_url}" },
    { "name": "PIWIK_URL", "value": "${var.piwik_url}" },
    { "name": "PIWIK_SITE_ID", "value": "${var.piwik_site_id}" },
    { "name": "REDIRECT_URI", "value": "${var.redirect_uri}" },
    { "name": "CACHE_POOL_SIZE", "value": "${var.cache_pool_size}" },
    { "name": "CACHE_SERVER", "value": "${var.cache_server}" },
    { "name": "COOKIE_DOMAIN", "value": "${var.cookie_domain}" },
    { "name": "COOKIE_NAME", "value": "${var.cookie_name}" },
    { "name": "COOKIE_SECURE_ONLY", "value": "${var.cookie_secure_only}" },
    { "name": "DEFAULT_SESSION_EXPIRATION", "value": "${var.default_session_expiration}" },
    { "name": "OAUTH2_REDIRECT_URI", "value": "${var.oauth2_redirect_uri}" },
    { "name": "OAUTH2_AUTH_URI", "value": "${var.oauth2_auth_uri}" }
  ]
}
