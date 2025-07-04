# Traffic 

## Load on the path

prometheus_http_requests_total{handler="/metrics"}[5m]

## Load - Request hit rate - HTTP Load on the system in last 5m - Rate of change in requests per second calculated over last 10m across all the paths / time series (reuqests / second) 0.8
sum(rate(prometheus_http_request_duration_seconds_count{}[5m]))

## DPR - Request duration over the last  5 minutes  (seconds / request) 0.006

sum(rate(prometheus_http_request_duration_seconds_sum[5m]))
/
sum(rate(prometheus_http_request_duration_seconds_count[5m]))

## DPR -  Request duration per request  - Aggregated per-path/method

sum by (handler) (rate(prometheus_http_request_duration_seconds_sum[5m]))
/
sum by (handler) (rate(prometheus_http_request_duration_seconds_count[5m]))

rate(prometheus_http_request_duration_seconds_sum[5m])
/
rate(prometheus_http_request_duration_seconds_count[5m])

## DPR - Request duration - Seconds / request since uptime - 0.002
sum(prometheus_http_request_duration_seconds_sum) / sum(prometheus_http_request_duration_seconds_count)

## TPS - Calculated over last 10 minutes - rps or tps - 170
sum(rate(prometheus_http_request_duration_seconds_count[5m])) / sum(rate(prometheus_http_request_duration_seconds_sum[5m]))

## TPS - Request per second calculated using since uptime - rps or tps - 195
sum(prometheus_http_request_duration_seconds_count) / sum(prometheus_http_request_duration_seconds_sum)

# Latency - Bucket Distribution

## Requests in buckets (cumulative) - grafana visulization
sum by (le) (prometheus_http_request_duration_seconds_bucket)

# Error Rate - rps
sum(rate(prometheus_http_requests_total{code!="200"}[5m]))

sum by (code) (prometheus_http_requests_total)

## rps Time (s) taken by 90% percentile of requests - task manager app data
histogram_quantile(0.9, sum by (le) (rate(prometheus_http_request_duration_seconds_bucket[5m])))

## 90% percentage of responses had bytes size response
histogram_quantile(0.9,sum by (le) (rate(prometheus_http_response_size_bytes_bucket{}[5m])))

# Other prometheus metrics
process_cpu_seconds_total
