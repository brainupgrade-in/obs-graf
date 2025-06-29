# Observability setup for spring boot app with OTEL instrumentation
## Loki - logs database
```bash
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/01-k8s-loki.yaml
```
## Tempo - Distributed log tracing using trace_id
```bash
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/02-k8s-tempo.yaml
```
## Promtail - to ship spring boot app logs to Loki 
### RBAC for promtail must (admin)
```bash
wget https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/03a-k8s-promtail-rbac.sh
./03a-k8s-promtail-rbac.sh <user|namespace>
```
### Promtail setup
```bash
wget https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/03b-k8s-promtail.yaml

sed -i 's/default/<user>/g' 03b-k8s-promtail.yaml
sed -i 's/\${POD_NAMESPACE}/<user>/g' 03b-k8s-promtail.yaml

kubectl apply -f 03b-k8s-promtail.yaml
```
## Prometheus setup
### Prometheus RBAC (admin)
```bash
wget https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/04-k8s-prometheus-rbac.sh

./04-k8s-prometheus-rbac.sh <user|namespace>
```
### Prometheus Config - To auto discover kubernetes services with annotation
Ensure that RBAC for prometheus is setup
```bash
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/01b-k8s-prometheus-configmap-svc-annotation.yaml

```
Update __NAMESPACE__ to <user> in prometheus config
```bash
kubectl edit cm prometheus-config
```
Assign sa to prometheus pods
```bash
kubectl set sa sts/prometheus prometheus
```

## Deploy spring boot app
```bash
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/05-k8s-obs-springboot-prom-otel.yaml
```

## Troubleshooting
If prometheus does not collect spring boot metrics then restart
```bash
kubectl rollout restart sts/prometheus
```

# UI Config
## Loki Config
### Enable Tempo -Derived Fields
```
    Name: TraceId Regex: (?:trace_id)=(\w+) 
    
    
    Query: # ${__value.raw}
```
OR 
```
(?:trace_id)=(\w+).*?(?:traceID)=(\w+)
```
Internal Link: Tempo

## Prometheus UI Config
Exemplars

Internal link Tempo
URL: ${__value.raw}
Label: trace_id

## Tempo UI config

### Trace to Logs
    Datasource: Loki
    Span start: -5m
    Span End: 5m
    Tags: pod
    Filter by trace ID: true

### Trace to Metrics
    Data Source: Prometheus
    Span start: -5m
    Span end: 5m
    Tags:  service.name as pod  http.route as uri

    Link Label: Request Rate  Query: sum by(uri)(rate(http_server_requests_seconds_count{$__tags}[1m]))

    Link Label: Error Rate  Query: 
    rate(http_server_requests_seconds_count{status="500"}[$__rate_interval])


# Dashboard - 17175
## Dashboard Variables
```
Application: app label_values(service)

Instance: app_name label_values(application)

Log Query: LogRef: log_keyword
```
## Panels changes

### Log type rate - Query

sum by(type) (rate({app=~"$app.*"} | pattern `<date> <time> <_>=<trace_id> <_>=<span_id> <_>=<trace_flags> <type> <_> --- <msg>` | type != "" |= "$log_keyword" [1m]))

### Logs of all spring boot panels - Query

{app=~"$app.*"} | pattern `<date> <time> <_>=<trace_id> <_>=<span_id> <_>=<trace_flags> <type> <_> --- <msg>` | line_format "{{.app}}\t{{.type}}\ttrace_id={{.trace_id}}\t{{.msg}}" |= "$log_keyword"

# Load Test
```bash
    kubectl create deploy loadtest --image brainupgrade/load-test
    kubectl exec -it deploy/loadtest -- bash
```
Run tmux and split the window in two halves (ctrl+b ")

## First tmux window pane
```bash
curl -fsslO https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/test-load.sh

chmod +x test-load.sh

./test-load.sh obs-springboot 10
```
## Second tmux window pane
```bash
curl -fsslO https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/apps/obs-springboot-prom-otel-tempo-loki/test.sh

chmod +x test.sh

while true; do ./test.sh obs-springboot ;sleep 5s;done
```

# Misc
## Tmux commands
```
Window split: ctrl+b "
Mouse option: ctrl+b :mouse on
```
# Grafana Dashboards
```
17175 - Springboot App
763 - redis
9628 - postgres
```