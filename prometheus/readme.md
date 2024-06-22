# Installation - Prometheus Grafana

## Kubernetes Cluster
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus --set server.persistentVolume.size=1Gi --set alertmanager.enabled=false --set kube-state-metrics.enabled=false --set prometheus-node-exporter.enabled=false --set prometheus-pushgateway.enabled=false

helm install grafana grafana/grafana

Password: kubectl get secret --namespace rajesh grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# use Cases
- Jenkins
- Mysql
- Nodes
- Prometheus https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/
- Kubernetes Cluster 
Api Server https://grafana.com/grafana/dashboards/12006-kubernetes-apiserver/
Node Exporter 11074
- Spring boot - Microservices Apps (prometheus-springboot, weather) 4701 12685 20729 6756
- Kafka
- JMS

## Springboot - simple
kubectl create deploy prometheus-springboot --image brainupgrade/prometheus-springboot:simple
kubectl expose deploy prometheus-springboot --port 80 --target-port 8080

## Springboot - weather

## Nginx Ingress Controller

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
--namespace ingress-nginx --create-namespace \
--set controller.metrics.enabled=true \
--set controller.metrics.serviceMonitor.enabled=true \
--set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"

# Queries
## Prometheus



## Jenkins

# Change app URL
## Patch Ingress with new service name
kubectl patch ingress obs --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"prometheus"}]'

# Prometheus Demo server
https://prometheus.demo.do.prometheus.io