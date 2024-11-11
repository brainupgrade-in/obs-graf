# Prom QLs

## GO GC Pause Duration - Summary (Bar Guage, Series option: Format - Heatmap, Instant)
go_gc_duration_seconds{job="prometheus"}

## Request Duration Latency Distribution (Histogram) (Bar Guage, Series option: Format - Heatmap, Instant)
sum by (le) (prometheus_http_request_duration_seconds_bucket{})

## Average Latency (s) / request/handler
rate(prometheus_http_request_duration_seconds_sum{}[5m]) / rate(prometheus_http_request_duration_seconds_count{}[5m])

## Average Latency / request
sum(rate(prometheus_http_request_duration_seconds_sum[5m]))/sum(rate(prometheus_http_request_duration_seconds_count[5m]))

## Percentile Distribution Histogram - Request duration seconds (time series)
histogram_quantile(0.99, rate(prometheus_http_request_duration_seconds_bucket[5m]))

histogram_quantile(0.9, rate(prometheus_http_request_duration_seconds_bucket[5m]))

histogram_quantile(0.5, rate(prometheus_http_request_duration_seconds_bucket[5m]))

histogram_quantile(0.1, rate(prometheus_http_request_duration_seconds_bucket[$__rate_interval]))

<!-- histogram_quantile(0.99, sum by (le) (rate(prometheus_http_request_duration_seconds_bucket[5m])))

histogram_quantile(0.9, sum by (le) (rate(prometheus_http_request_duration_seconds_bucket[5m])))

histogram_quantile(0.5, sum by (le) (rate(prometheus_http_request_duration_seconds_bucket[5m])))

histogram_quantile(0.1, sum by (le) ( rate(prometheus_http_request_duration_seconds_bucket[$__rate_interval]))) -->

## Response size distribution (Bar gauge, series format: heatmap)
sum by (le) (prometheus_http_response_size_bytes_bucket{})

## Response size distribution -Quantile (Time series)
histogram_quantile(0.9,sum by (le) (prometheus_http_response_size_bytes_bucket{}))

histogram_quantile(0.99,sum by (le) (prometheus_http_response_size_bytes_bucket{}))

## Load on Prometheus - RPS Request Per Second
sum (rate(prometheus_http_requests_total{}[5m]))

## Average Response size (bytes) / request
sum(rate(prometheus_http_response_size_bytes_sum[5m]))/sum(rate(prometheus_http_response_size_bytes_count[5m]))

## Network Connections - Open
net_conntrack_listener_conn_accepted_total  - net_conntrack_listener_conn_closed_total