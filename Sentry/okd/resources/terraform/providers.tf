terraform {
  required_providers {
    sentry = {
      source = "jianyuan/sentry"
    }
  }
}

# Configure the Sentry Provider
provider "sentry" {
  base_url  = var.sentry_url
  token     = var.sentry_auth_token
}
