#!/bin/sh

kubectl apply -f monitoring/namespace.yml

# prom and grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --values monitoring/prometheus/values.yaml \
    --wait \
    --timeout 10m

# loki and promtail
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki-stack  \
  --values monitoring/loki-stack/values.yaml \
  --namespace monitoring


helm repo add tempo https://grafana.github.io/helm-charts 
helm install tempo grafana/tempo  \
  --namespace monitoring

echo "http://grafana.localhost"
