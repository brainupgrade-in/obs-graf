# telegraf k8s setup
https://github.com/influxdata/helm-charts/blob/master/charts/telegraf/README.md
helm repo add influxdata https://helm.influxdata.com/
helm repo update
helm upgrade --install telegraf influxdata/telegraf --namespace influxdb --create-namespace --set persistence.enabled=true -f telegraf-values.yaml

# Telegraf - Operator
helm upgrade --install telegraf-operator influxdata/telegraf-operator
Uses the secret object telegraf-operator-classes

