helm repo add influxdata https://helm.influxdata.com/
helm repo update
helm upgrade --install influxdb influxdata/influxdb2 --namespace influxdb --create-namespace -f influxdb-values.yaml
<!-- helm upgrade --install influxdb influxdata/influxdb3-clustered -f influxdb3-clustered-values.yml --namespace influxdb -->
kubectl port-forward -n influxdb service/influxdb 8086:8086

helm install influxdb influxdata/influxdb2 --namespace influxdb


# Kong ingress
install kong
https://docs.konghq.com/kubernetes-ingress-controller/latest/get-started/
helm repo add kong https://charts.konghq.com
helm repo update

helm install kong kong/ingress -n kong --create-namespace 
# k8s monitoring
https://www.influxdata.com/blog/monitoring-kubernetes-architecture/
# Misc
echo -n 'admin:admin123@influx.brainupgrade.in/default' | base64
k create secret generic influxdb-dsn-secret -n influxdb --from-literal=dsn=YWRtaW46YWRtaW4xMjNAaW5mbHV4LmJyYWludXBncmFkZS5pbi9kZWZhdWx0
# influxdb API token
API Token from influx UI: jenkins ODgoLFim1Ycl3aIOENDewrwrR3olslK65qJyD0YZXTVvclzQRagvtAippyjQ0Qh-9a61mRvw6ditFspvXdzmeg==
# telegraf k8s setup
https://github.com/influxdata/helm-charts/blob/master/charts/telegraf/README.md
helm repo add influxdata https://helm.influxdata.com/
helm repo update
helm upgrade --install telegraf influxdata/telegraf --namespace influxdb --create-namespace --set persistence.enabled=true -f telegraf-values.yaml

# Telegraf - Operator
helm upgrade --install telegraf-operator influxdata/telegraf-operator
Uses the secret object telegraf-operator-classes

# Dashboards - influxdb
928 - telegraf
421 - influx internals
1443 - telegraf host metrics
https://grafana.com/grafana/dashboards/10557-jenkins-build-status/
https://grafana.com/grafana/dashboards/928-telegraf-system-dashboard/

# References:
https://www.influxdata.com/blog/monitoring-jenkins-with-influxdb/
https://www.influxdata.com/blog/monitoring-kubernetes-architecture/
https://github.com/influxdata/telegraf-operator#pod-level-annotations
https://grafana.com/grafana/dashboards/19419-opentelemetry-apm/