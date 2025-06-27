# Deploy app - Admin
kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/dockerk8s/refs/heads/main/kubernetes/lab/07-statefulset/jenkins/jenkins.yaml

# Configure service with annotation - Admin
kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/06-jenkins-prometheus-service.yaml

# Prometheus config
Include jenkins namespace using regex 
```
jenkins|othernamespace
```