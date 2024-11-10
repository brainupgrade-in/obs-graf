# Loki - Tempo
Derived Fields
    Name: TraceId Regex: (?:trace_id)=(\w+) 
    
    
    Query: # ${__value.raw}

OR (?:trace_id)=(\w+).*?(?:traceID)=(\w+)
    

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
    Tags:  service.name as pod  http.route as uri

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
    cd obs-graf/apps/obs-springboot-prom-otel-tempo-loki
    ./test-load.sh obs-springboot.<user> 10

-- second half

    cd obs-graf/apps/obs-springboot-prom-otel-tempo-loki
    while true; do ./test.sh obs-springboot.<user> ;sleep 5s;done

# Dashboard Variables
app_name lable_values(application)

LogRef:

log_keyword

app label_values(application)

# Dashboard panels

Log type rate:

sum by(type) (rate({app=~"$app.*"} | pattern `<date> <time> <_>=<trace_id> <_>=<span_id> <_>=<trace_flags> <type> <_> --- <msg>` | type != "" |= "$log_keyword" [1m]))

Logs of all spring boot panels:

{app=~"$app.*"} | pattern `<date> <time> <_>=<trace_id> <_>=<span_id> <_>=<trace_flags> <type> <_> --- <msg>` | line_format "{{.app}}\t{{.type}}\ttrace_id={{.trace_id}}\t{{.msg}}" |= "$log_keyword"

# Tmux commands
Window split: ctrl+b "
Mouse option: ctrl+b :mouse on


# Misc - Promtail

helm upgrade --install promtail  grafana/promtail -f promtail-helm-values.yaml