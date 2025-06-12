# Deployment
```bash
kubectl create deploy observability-springboot-rabbitmq --image brainupgrade/observability-springboot-rabbitmq:1

kubectl expose deploy observability-springboot-rabbitmq --port 80 --target-port 8080
```

# k8s auto discovery config
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/rabbitmq-prometheus-service.yaml