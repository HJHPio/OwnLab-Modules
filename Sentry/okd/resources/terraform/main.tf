# Fetch organization
data "sentry_organization" "main" {
  # Taken from URL: https://sentry.example.local/organizations/[slug]/issues/
  slug = "sentry"
}

# Create a team
resource "sentry_team" "okd" {
  organization = data.sentry_organization.main.id
  name         = "OKD monitoring team"
}

# Create a project
resource "sentry_project" "k8s-okd-agent" {
  organization = data.sentry_organization.main.id

  teams = [sentry_team.okd.id]
  name  = "K8s (OKD) agent"
  slug  = "k8s-okd-agent"

  platform    = "other"
  resolve_age = 720

  default_rules = false
}

# Fetch project key
data "sentry_key" "k8s-okd-agent-key" {
  organization = sentry_project.k8s-okd-agent.organization
  project      = sentry_project.k8s-okd-agent.id

  first = true
}

# Fetch admin
data "sentry_organization_member" "admin-user" {
  organization = sentry_project.k8s-okd-agent.organization
  email        = var.sentry_admin_email
}

# Add admin as okd monitoring team member
resource "sentry_team_member" "okd-team-member" {
  organization = sentry_project.k8s-okd-agent.organization
  team         = sentry_team.okd.id
  member_id    = data.sentry_organization_member.admin-user.id
}
