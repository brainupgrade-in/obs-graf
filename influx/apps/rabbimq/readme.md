

https://grafana.com/grafana/dashboards/8495-rabbitmq-monitoring/ (telegraf elasticsearch grafana)
https://www.rabbitmq.com/docs/prometheus

# Enable prometheus metrics scrapping
kubectl apply -f rabbitmq-prometheus-service.yaml

# Grafana Dashboard
## Prometheus
10991 - RabbitMQ Overview
6566 - RabbiMQ Performance
11352 - System Internal - Erlang
## InfluxDB
5780 - RabbitMQ Overview
10493 - RabbiMQ