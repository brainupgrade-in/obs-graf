# Log Queries

{pod=~".+"}

Errors across namespaces
sum(count_over_time({namespace=~".+"} |= "error" [$__range]))

Average response time in a namespace by path and app
avg_over_time({namespace=~".+"} | pattern "<date> <time> <access> <level>     <code> <method> <path> <ip> <latency>" | regexp "(?P<latencyDecimal>[0-9]+\\.[0-9]+ms)" | line_format "{{.latencyDecimal}}" | regexp "(?P<latencyClean>[0-9]+\\.[0-9])" | unwrap latencyClean | __error__="" | path!="/alive" | path!="/ready" [$__interval]) by (path, app)
