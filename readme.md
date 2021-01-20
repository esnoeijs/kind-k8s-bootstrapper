# kind k8s bootstrapper

## description

Some scripts to quickly setup a local k8s cluster with KIND and install prom/loki/graf/jaeger

includes nginx ingresses that will bind to port 80 and 443

It's based on helm v2 charts so already deprecated ^-^ 

based on https://github.com/chris-cmsoft/kubernetes-bootstrapper

## usage

```bash
./kind-build-cluster.sh
./bootstrap-cluster.sh
```