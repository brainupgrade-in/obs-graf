# Installation of Prometheus on Ubuntu

## Pre-setup
    kubectl create deploy ubuntu --image ubuntu -- tail -f /dev/null
    kubectl expose deploy ubuntu --name ubuntu-influx --port 80 --target-port 8086
    kubectl patch ingress <user>-inf.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"ubuntu-influx"}]'

## Optional
    kubectl expose deploy ubuntu --name ubuntu-prom --port 80 --target-port 9090
    kubectl expose deploy ubuntu --name ubuntu-grafana --port 80 --target-port 3000
## Influxdb  Installation
tmux
    kubectl exec -it deploy/ubuntu -- bash
    apt update && apt install -y wget curl
    curl -LO https://download.influxdata.com/influxdb/releases/influxdb2-2.7.6_linux_amd64.tar.gz
    tar xvzf ./influxdb2-2.7.6_linux_amd64.tar.gz
    cp ./influxdb2-2.7.6/usr/bin/influxd /usr/local/bin/
    ./influxdb2-2.7.6/usr/bin/influxd


## Verification
https://<user>-inf.brainupgrade.in

