# Deployment
```bash
kubectl create deploy observability-springboot-rabbitmq --image brainupgrade/observability-springboot-rabbitmq:1

kubectl expose deploy observability-springboot-rabbitmq --port 80 --target-port 8080
```