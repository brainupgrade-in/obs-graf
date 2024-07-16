# Deploy the Cache app
kubectl apply -f k8s-cache-guava.yaml
# Add the datasource of type influxdb
- Select influxQL
- Add header (key: Authorization   value: Token <token>)
- Add bucket=springboot, org=org, user=, password=

# Grafana Dashboard 
## InfluxDB
20668 (JVM & DB Metrics - Micrometer)

# Custom metrics - hello

## InfluxQL
select max("value") from "hello" 

## Flux QL
from(bucket: "springboot")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "hello")
  |> filter(fn: (r) => r._field == "value")
  |> max()