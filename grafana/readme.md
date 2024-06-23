# Dashboard variables
Regex to filter and avoid system label names
/^(?!__name_)/

## Prom Host
Query: label_values(node_uname_info{job="$promJob"},nodename)
## Instance


# Network transfer (Time Series using repeat panel)
rate(node_network_receive_bytes_total{job="node",instance=~"$instance"}[1m])
rate(node_network_transmit_bytes_total{job="node",instance=~"$instance"}[1m])

# To reset admin password
grafana-0:/usr/share/grafana/bin$ ./grafana-cli admin reset-admin-password <password>