# App Setup
kubectl create deploy taskmanager --image brainupgrade/prometheus-springboot-taskmanager
kubectl expose deploy taskmanager --port 80 --target-port 8080

# Update prometheus.yaml with the target
      - job_name: 'taskmanager'
        metrics_path: '/actuator/prometheus'
        static_configs:
          - targets: ['taskmanager']

# Load generator
kubectl create deploy test --image brainupgrade/tshoot
kubectl exec -it test -- bash
for i in {1..30};do curl -s taskmanager/api/test/slow?delay=10;done

for i in {1..1};do curl -X POST -H "Content-Type: application/json" -d "{\"title\":\"Task $i\"}" https://mtvlabk8s-taskmanager.brainupgrade.in/api/todos ; done

for i in {1..1};do curl -X GET https://mtvlabk8s-taskmanager.brainupgrade.in/api/test/slow?delay=10 ; done

# Request latency distribution
histogram_quantile(0.5,sum by (le) (rate(slow_request_seconds_bucket{job="taskmanager",uri="/api/test/slow"}[5m])))

# Overall request distribution

sum by (le) (http_server_requests_seconds_bucket{job="taskmanager"})

# Rate of status including errors
sum by (status) (rate(http_server_requests_seconds_count[5m]))

# For auto discovery using service annotation
kubectl annotate svc taskmanager prometheus.io/scrape="true" prometheus.io/port="8080" prometheus.io/path="/actuator/prometheus"

# Set prometheus metrics tags
k set env deploy taskmanager management.metrics.tags.application=taskmanager management.metrics.tags.service=taskmanager