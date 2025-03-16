# Helm Charts source
This is usage example of those charts: https://github.com/sentry-kubernetes/charts.

# Initialization of SentryIO on OKD  
Update ```values-k8s-*-example.yaml``` files with customs to ```values-k8s-*.yaml```.  
Examples are shown here:
- https://github.com/sentry-kubernetes/charts/blob/develop/charts/sentry/values.yaml
- https://github.com/sentry-kubernetes/charts/blob/develop/charts/sentry-kubernetes/values.yaml

Create file okd/resources/sentry-route.yaml based on okd/resources/sentry-route-example.yaml 

```sh
helm repo add sentry https://sentry-kubernetes.github.io/charts
helm repo update
helm search repo sentry/sentry --versions
```

```sh
oc new-project sentry-main

oc adm policy add-scc-to-user anyuid -z sentry-main-clickhouse-sa -n sentry-main
oc adm policy add-scc-to-user anyuid -z sentry-main-postgres-sa -n sentry-main
oc adm policy add-scc-to-user anyuid -z sentry-main-sentry-redis -n sentry-main
oc adm policy add-scc-to-user anyuid -z sentry-main-rabbitmq -n sentry-main
oc adm policy add-scc-to-user anyuid -z sentry-main-zookeeper-sa -n sentry-main
oc apply -f okd/resources/sentry-route.yaml

helm install sentry-main sentry/sentry --version 26.15.1 --wait --timeout=3600s --debug -f okd/values-k8s-main.yaml
```

# Setup Kubernetes Sentry Agent on OKD
Create in Sentry 'other' project and save DSN.
Update INSERT_DSN_HERE in file okd/values-k8s-issuer.yaml.  
```sh
oc new-project sentry-issuer
helm install sentry-issuer sentry/sentry-kubernetes --version 0.4.0 -f okd/values-k8s-issuer.yaml
```

# Terraform example
Go to: https://sentry-okd.example.local/settings/sentry/developer-settings/new-internal/
and generate new token for terraform provider in tfvars sentry_auth_token.
```sh
tofu init
tofu plan 
yes yes | tofu apply 
```

# Updates
```sh
# NOTES:
# * When running upgrades, make sure to give back the `system.secretKey` value.

# oc get secret sentry-main-sentry-secret  -n sentry-main -o jsonpath="{.data.key}" | base64 --decode
# oc -n sentry-main get configmap sentry-main-sentry -o json | grep -m1 -Po '(?<=system.secret-key: )[^\\]*'

# helm upgrade sentry-main sentry/sentry --version 26.11.2 -f okd/values-k8s-main.yaml
```

# Clean
```sh
helm uninstall sentry-issuer
oc delete project sentry-issuer
helm uninstall sentry-main
oc delete project sentry-main
```

# Known bugs:
- With Emails enabled in initiall configuration setup admin need to modify request before proceeding: https://github.com/getsentry/self-hosted/issues/3186#issuecomment-2337672162

# TODO:
- Research limits and requests for every missing deployment/statefullset
