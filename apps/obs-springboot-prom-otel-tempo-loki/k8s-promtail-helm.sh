#!/bin/bash

helm upgrade --install promtail grafana/promtail --version 6.16.3 -n tracing -f - << 'EOF'
extraVolumes:
  - name: node-logs
    hostPath:
      path: /var/log

extraVolumeMounts:
  - name: node-logs
    mountPath: /var/log/host
    readOnly: true
config:    
  clients:
    - url: http://loki:3100/loki/api/v1/push
EOF