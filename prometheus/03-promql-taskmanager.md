# App Setup
```bash
  kubectl create deploy taskmanager --image brainupgrade/prometheus-springboot-taskmanager
  kubectl expose deploy taskmanager --port 80 --target-port 8080
```
# Update prometheus.yaml with the target
```yaml
      - job_name: 'taskmanager'
        metrics_path: '/actuator/prometheus'
        static_configs:
          - targets: ['taskmanager']
```
## Prometheus config
```yaml
    prometheus.yml: |
      global:
        scrape_interval: 15s
      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ['localhost:9090']
        - job_name: 'taskmanager'
          metrics_path: '/actuator/prometheus'
          static_configs:
            - targets: ['taskmanager']       
```
# App Annotations
```bash
k set env deploy/taskmanager management.metrics.tags.application=taskmanager management.metrics.tags.service=taskmanager               

k annotate svc/taskmanager prometheus.io/scrape="true" prometheus.io/port="8080" prometheus.io/path="/actuator/prometheus"
```
# Load generator
```bash
    kubectl create deploy test --image brainupgrade/tshoot

    kubectl exec -it deploy/test -- bash
    
    for i in {1..30};do curl -s taskmanager/api/test/slow?delay=10;done

    for i in {1..1};do curl -X POST -H "Content-Type: application/json" -d "{\"title\":\"Task $i\"}" taskmanager/api/todos ; done

    for i in {1..1};do curl -X GET taskmanager/api/test/slow?delay=10 ; done



    for i in {1..1};do curl -X POST -H "Content-Type: application/json" -d "{\"title\":\"Task $i\"}" https://mtvlabk8s-taskmanager.brainupgrade.in/api/todos ; done

    for i in {1..1};do curl -X GET https://mtvlabk8s-taskmanager.brainupgrade.in/api/test/slow?delay=10 ; done
```
# Prom QLs
## Request latency distribution
histogram_quantile(0.5,sum by (le) (rate(slow_request_seconds_bucket{job="taskmanager",uri="/api/test/slow"}[5m])))

## Overall request distribution

sum by (le) (http_server_requests_seconds_bucket{job="taskmanager"})

## Rate of status including errors
sum by (status) (rate(http_server_requests_seconds_count[5m]))

## 50th Percentile (Median) of HTTP Request Durations:

histogram_quantile(0.5, sum(rate(http_server_requests_seconds_bucket{job="taskmanager"}[5m])) by (le))

## 95th percentile of HTTP request duration
histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket{job="taskmanager"}[5m])) by (le))

## Alert if 99th Percentile Response Time Exceeds 400ms
histogram_quantile(0.99, sum(rate(http_server_requests_seconds_bucket{job="taskmanager"}[5m])) by (le)) > 0.4

## Total Number of Requests in the Last Hour:
increase(http_server_requests_seconds_count{job="taskmanager"}[15m])

## Requests per Second (RPS) Rate:
rate(http_server_requests_seconds_count{job="taskmanager"}[5m])


## Percentage of Requests Served Under 200ms (SLO Compliance)
sum(rate(http_server_requests_seconds_bucket{job="taskmanager", le="0.2"}[5m])) 
/
sum(rate(http_server_requests_seconds_count{job="taskmanager"}[5m])) * 100

# Grafana Dashboard 
12685 - Kancy Spring Boot 

# Misc
# For auto discovery using service annotation
kubectl annotate svc taskmanager prometheus.io/scrape="true" prometheus.io/port="8080" prometheus.io/path="/actuator/prometheus"

# Set prometheus metrics tags
k set env deploy taskmanager management.metrics.tags.application=taskmanager management.metrics.tags.service=taskmanager
