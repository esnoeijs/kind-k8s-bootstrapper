#!/bin/sh

kubectl apply -f helm/service-account.yml
kubectl apply -f helm/role-binding.yml
helm init --service-account tiller --wait
kubectl apply -f monitoring/namespace.yml

# we don't use the helm chart because we don't need a cluster, just one node.
kubectl apply -f monitoring/elastic/app.yaml -n monitoring

# we do prom separate from the loki stack because we need to pass an option so it will ignore jaeger
helm install stable/prometheus \
    -f monitoring/prometheus/values.yml \
    --namespace monitoring \
    --name prometheus \
    --wait \
    --timeout 600

helm install jaegertracing/jaeger \
  --values monitoring/jaeger/values.yaml \
	--namespace monitoring \
	--name jaeger \
	--wait \
	--timeout 600


helm install grafana/loki-stack \
 --values monitoring/loki-stack/values.yaml \
 --namespace monitoring \
 --name loki \
 --wait \
 --timeout 600

# the loki helm chart doesn't like if we pre-insert the prom stack configmap for auto-configuring.
# so we simply overwrite it afterwards and kick the grafana pod so the changed configmap gets picked up
kubectl apply -f monitoring/prom-stack-configmap.yaml --wait
kubectl delete pods -n monitoring -l app.kubernetes.io/name=grafana


kubectl apply -f monitoring/ingress.yaml --wait

kubectl get secret \
    --namespace monitoring \
    loki-grafana \
    -o jsonpath="{.data.admin-password}" \
    | base64 --decode ; echo
