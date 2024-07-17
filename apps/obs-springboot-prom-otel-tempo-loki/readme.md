# Loki - Tempo
Derived Fields
    Regex: (?:trace_id)=(\w+)    OR (?:trace_id)=(\w+).*?(?:traceID)=(\w+)
    Query: # ${__value.raw}

Internal Link: Tempo

# Prometheus
Exemplars

Internal link Tempo
URL: ${__value.raw}
Label: trace_id

# Tempo config

## Trace to Logs
    Datasource: Loki
    Span start: -5m
    Span End: 5m
    Tags: pod
    Filter by tracke ID: true

## Trace to Metrics
    Data Source: Prometheus
    Span start: -5m
    Span end: 5m
    Tags:  service.name as pod  http.rout as uri

    Link Label: Request Rate  Query: sum by(uri)(rate(http_server_requests_seconds_count{$__tags}[1m]))

    Link Label: Error Rate  Query: sum by (client, server)(rate(traces_service_graph_request_failed_total{$__tags}{$__rate_interval))

# Grafana
17175 - Springboot Observability


# Load Test
    kubectl create deploy loadtest --image jstarcher/siege -- "tail" "-f" "/dev/null"
    kubectl exec -it deploy/loadtest -- sh
    apk update && apk add bash git tmux curl
-- split the window in two halves (ctrl+b ")
-- first half
    git clone https://github.com/brainupgrade-in/obs-graf
    cd obs-graf/app/obs-springboot-prom-otel-tempo-loki
    ./test-load.sh obs-springboot.<user> 10
-- second half
    cd obs-graf/app/obs-springboot-prom-otel-tempo-loki
    ./test.sh obs-springboot.<user> 10


# Tmux commands
Window split: ctrl+b "
Mouse option: ctrl+b :mouse on


# Misc - Promtail

helm upgrade --install promtail  grafana/promtail -f promtail-helm-values.yaml