# Installation of Prometheus on Ubuntu

## Pre-setup

```bash
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/apps/ubuntu/ubuntu-obs.yaml

kubectl patch ingress <user>-prom.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"ubuntu-obs"}]'
```

## Prometheus Installation

```bash
tmux
kubectl exec -it deploy/ubuntu-obs -- bash
cd /opt
tar -xvzf prometheus-2.55.1.linux-amd64.tar.gz 
cd prometheus-2.55.1.linux-amd64
./prometheus
```

## Verification
https://<user>-prom.brainupgrade.in

## Prometheus metrics
```bash
kubectl create deploy test --image brainupgrade/tshoot
kubectl exec -it deploy/test -- bash
curl ubuntu-obs:9090/metrics
```

## Node Exporter
https://github.com/prometheus/node_exporter/releases