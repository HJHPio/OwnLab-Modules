variable "sentry_url" {
  type        = string
  sensitive   = false
  default     = "https://sentry-okd.example.local/api/"
}
variable "sentry_auth_token" {
  type        = string
  sensitive   = true
}
variable "sentry_admin_email" {
  type        = string
  sensitive   = true
}