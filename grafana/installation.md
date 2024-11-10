# Installation of Grafana on Ubuntu

## Pre-setup (if not done already)

```bash
kubectl apply -f kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/apps/ubuntu/ubuntu-obs.yaml

kubectl patch ingress <user>-obs.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"ubuntu-obs"}]'
```

## Grafana Installation

```bash
tmux

kubectl exec -it deploy/ubuntu-obs -- bash

apt-get install -y adduser libfontconfig1 musl

#wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.3.0_amd64.deb

cd /opt && dpkg -i grafana-enterprise_11.3.0_amd64.deb

service grafana-server start
```

## Verification
https://<user>-obs.brainupgrade.in

