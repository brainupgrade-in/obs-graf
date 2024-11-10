# Installation of Prometheus on Ubuntu
## Pre-setup
kubectl create deploy ubuntu --image ubuntu -- tail -f /dev/null
kubectl expose deploy ubuntu --name ubuntu-prom --port 80 --target-port 9090
kubectl expose deploy ubuntu --name ubuntu-grafana --port 80 --target-port 3000
kubectl patch ingress <user>-prom.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"ubuntu-prom"}]'
## Prometheus Installation
tmux
kubectl exec -it deploy/ubuntu -- bash
apt update && apt install -y wget curl
wget https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz 
mkdir -p /prometheus
tar -xvzf prometheus-2.55.1.linux-amd64.tar.gz -C /prometheus --strip-components=1
cd prometheus
./prometheus

## Verification
https://<user>-prom.brainupgrade.in

## Prometheus metrics
kubectl create deploy test --image brainupgrade/tshoot
kubectl exec -it deploy/test -- bash
curl ubuntu-prom/metrics

## Node Exporter
https://github.com/prometheus/node_exporter/releases