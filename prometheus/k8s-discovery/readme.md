# Kubernetes Cluster monitoring  using prometheus

helm upgrade prometheus prometheus-community/kube-prometheus-stack \
--namespace monitoring  \
--set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
--namespace ingress-nginx --create-namespace \
--set controller.metrics.enabled=true \
--set controller.metrics.serviceMonitor.enabled=true \
--set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"    





ServiceMonitor (custom k8s )
release: prometheus   (k8s services)

# Admin
for i in {1..23};do kubectl label ns mtvlabeksu$i pod-security.kubernetes.io/enforce-  ; done