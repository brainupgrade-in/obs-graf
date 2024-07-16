# Deploy Jenkins
    kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/dockerk8s/main/kubernetes/lab/07-statefulset/jenkins/jenkins.yaml
## Enable prometheus metrics scrapping
    kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/main/prometheus/ks8-discovery/jenkins-prometheus-service.yaml

# Enable Prometheus to scrape apps with svc annotation
    kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/main/prometheus/ks8-discovery/k8s-prometheus-configmap-svc-annotation.yaml
    kubectl set sa sts/prometheus prometheus
    kubectl rollout restart sts prometheus

# Login into jenkins and add plugin influxdb and configure
    bucket jenkins
    URL  influxdb.<namespace>.svc:8086
    token
    org org

# Add InfluxDB datasource to grafana
## InfluxQL
    http://influxdb:8086
    org org
    bucket jenkins
    Header Name: Authorization
    Header value: Token <token>
## FlexQL
    http://influxdb:8086
    org org
    bucket jenkins
    token <token>

# Grafana Dashboard





## Jenkins Monitoring (14550)
Ref: https://grafana.com/grafana/dashboards/14550-jenkins-monitoring/