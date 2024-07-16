# Loki - Tempo
    Regex: (?:trace_id)=(\w+)
    Query: # ${__value.raw}

# Grafana
17175 - Springboot Observability


# Load Test
    kubectl create deploy loadtest --image jstarcher/siege -- "tail" "-f" "/dev/null"
    kubectl exec -it deploy/loadtest -- sh
    apk update && apk add bash git tmux
-- split the window in two halves
-- first half
    git clone https://github.com/brainupgrade-in/obs-graf
    cd obs-graf/app/obs-springboot-prom-otel-tempo-loki
    ./test-load.sh obs-springboot.<user> 10
-- second half
    cd obs-graf/app/obs-springboot-prom-otel-tempo-loki
    ./test.sh obs-springboot.<user> 10



# Misc - Promtail

helm upgrade --install promtail  grafana/promtail -f promtail-helm-values.yaml