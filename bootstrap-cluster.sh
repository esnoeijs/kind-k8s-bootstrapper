#!/bin/sh

kubectl apply -f monitoring/namespace.yml

# we don't use the helm chart because we don't need a cluster, just one node.
kubectl apply -f monitoring/elastic/app.yaml -n monitoring

# prom and grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --values monitoring/prometheus/values.yaml \
    --wait \
    --timeout 10m

# jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install jaeger jaegertracing/jaeger \
  --values monitoring/jaeger/values.yaml \
	--namespace monitoring

# loki and promtail
helm repo add grafana https://grafana.github.io/helm-charts
helm install loki grafana/loki-stack  \
  --values monitoring/loki-stack/values.yaml \
  --namespace monitoring

echo "http://grafana.localhost"
echo "http://jaeger.localhost"
