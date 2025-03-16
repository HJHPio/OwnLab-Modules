# Module Uptime Kuma example
Helm source: https://github.com/k3rnelpan1c-dev/uptime-kuma-helm  
Original project repo: https://github.com/louislam/uptime-kuma

This setup serves as an **example** for **hosting mentioned open-source project in a personal (own) lab environment**.

# 1. Install helm
```sh
helm repo add k3 https://k3rnelpan1c-dev.github.io/uptime-kuma-helm/
helm repo update
helm search repo k3/uptime-kuma --versions
```

# 2. Update values.yaml and deploy uptime-kuma
```sh
cp okd/values-example.yaml okd/values.yaml && vi okd/values.yaml
oc new-project monitoring
helm install uptime-kuma k3/uptime-kuma --version 1.4.0 -f okd/values.yaml
```

# 3.*(optional) Service monitoring is possible (prometheus integration) - Create API token in GUI and apply secret
https://github.com/k3rnelpan1c-dev/uptime-kuma-helm?tab=readme-ov-file#usage
```sh
cp okd/secret-example.yaml okd/secret.yaml && vi okd/secret.yaml
oc apply -f okd/secret.yaml
helm upgrade uptime-kuma k3/uptime-kuma --version 1.4.0 -f okd/values.yaml
```
