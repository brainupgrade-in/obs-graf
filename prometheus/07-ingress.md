

# Configure service with annotation - Admin
kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/07-ingress-prometheus-service.yaml

# Prometheus config
Include  namespace using regex 
```
ingress-nginx|othernamespace
```