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

# Request latency distribution
histogram_quantile(0.5,sum by (le) (rate(slow_request_seconds_bucket{job="taskmanager",uri="/api/test/slow"}[5m])))
