# Installation of Grafana on Ubuntu
## Pre-setup (if not done already)
kubectl create deploy ubuntu --image ubuntu -- tail -f /dev/null
kubectl expose deploy ubuntu --name ubuntu-prom --port 80 --target-port 9090
kubectl expose deploy ubuntu --name ubuntu-grafana --port 80 --target-port 3000
kubectl patch ingress <user>-obs.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"ubuntu-obs"}]'
## Grafana Installation
tmux
kubectl exec -it deploy/ubuntu -- bash
apt update && apt install -y wget curl

apt-get install -y adduser libfontconfig1 musl
#wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.3.0_amd64.deb
cd /opt && dpkg -i grafana-enterprise_11.3.0_amd64.deb

service grafana-server start

## Verification
https://<user>-obs.brainupgrade.in

