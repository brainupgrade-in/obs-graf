#!/bin/bash

helm upgrade --install tempo grafana/tempo --version 1.10.1 -n tracing -f - << 'EOF'
tempo:
 extraArgs:
   "distributor.log-received-spans.enabled": true
   "distributor.log-received-spans.include-attributes": true
 receivers:
   zipkin:
   otlp:
     protocols:
       http:
       grpc:
EOF

helm install loki grafana/loki-stack --version 2.10.2 -n tracing -f - << 'EOF'
fluent-bit:
 enabled: false
promtail:
 enabled: true
prometheus:
 enabled: false
 alertmanager:
   persistentVolume:
     enabled: false
 server:
   persistentVolume:
     enabled: false
EOF

kubectl apply -n tracing -f https://raw.githubusercontent.com/antonioberben/examples/master/opentelemetry-collector/otel.yaml

kubectl apply -n tracing -f - << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
 name: otel-collector-conf
 labels:
   app: opentelemetry
   component: otel-collector-conf
data:
 otel-collector-config: |
   receivers:
     zipkin:
       endpoint: 0.0.0.0:9411
   exporters:
     otlp:
       endpoint: tempo.tracing.svc.cluster.local:55680
       insecure: true
   service:
     pipelines:
       traces:
         receivers: [zipkin]
         exporters: [otlp]
EOF

helm repo add fluent https://fluent.github.io/helm-charts

helm repo update

helm install fluent-bit fluent/fluent-bit --version 0.47.2 -n tracing -f - << 'EOF'
logLevel: trace
config:
 service: |
   [SERVICE]
       Flush 1
       Daemon Off
       Log_Level trace
       Parsers_File custom_parsers.conf
       HTTP_Server On
       HTTP_Listen 0.0.0.0
       HTTP_Port {{ .Values.service.port }}
 inputs: |
   [INPUT]
       Name tail
       Path /var/log/containers/*.log
       Parser cri
       Tag kube.*
       Mem_Buf_Limit 5MB
 outputs: |
   [OUTPUT]
       name loki
       match *
       host loki.tracing.svc
       port 3100
       tenant_id ""
       labels job=fluentbit
       label_keys $trace_id
       auto_kubernetes_labels on
 customParsers: |
   [PARSER]
       Name cri
       Format regex
       Regex ^(?<time>[^ ]+) (?<stream>stdout|stderr) (?<logtag>[^ ]*) (?<message>.*)$
       Time_Key    time
       Time_Format %Y-%m-%dT%H:%M:%S.%L%z
EOF

helm install grafana grafana/grafana -n tracing --version 8.3.4  -f - << 'EOF'
datasources:
 datasources.yaml:
   apiVersion: 1
   datasources:
     - name: Tempo
       type: tempo
       access: browser
       orgId: 1
       uid: tempo
       url: http://tempo.tracing.svc:3100
       isDefault: true
       editable: true
     - name: Loki
       type: loki
       access: browser
       orgId: 1
       uid: loki
       url: http://loki.tracing.svc:3100
       isDefault: false
       editable: true
       jsonData:
         derivedFields:
           - datasourceName: Tempo
             matcherRegex: "traceID=(\\w+)"  # (?:trace_id)=(\w+)
             name: TraceID
             url: "$${__value.raw}"  # ${__value.raw}
             datasourceUid: tempo

env:
 JAEGER_AGENT_PORT: 6831

adminUser: mtvlabk8s
adminPassword: mtvlabk8s

service:
 type: NodePort

EOF