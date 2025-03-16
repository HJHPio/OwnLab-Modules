output "organization" {
  value = data.sentry_organization.main
}

output "team" {
  value = resource.sentry_team.okd.id
}

output "project" {
  value = resource.sentry_project.k8s-okd-agent.id
}

output "k8s-okd-agent-dsn" {
  value = data.sentry_key.k8s-okd-agent-key.dsn
}
