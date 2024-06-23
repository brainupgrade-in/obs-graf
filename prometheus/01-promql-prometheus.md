# Traffic 

## Average request duration over the last  5 minutes

rate(prometheus_http_request_duration_seconds_sum[5m])
/
rate(prometheus_http_request_duration_seconds_count[5m])

## Aggregated per-path/method average request duration

sum by (handler) (rate(prometheus_http_request_duration_seconds_sum[5m]))
/
sum by (handler) (rate(prometheus_http_request_duration_seconds_count[5m]))


## Load on the system in last 10m - Rate of change in requests per second calculated over last 10m across all the paths / time series
sum(rate(prometheus_http_request_duration_seconds_count{}[10m]))
0.1

# Capacity
## Request per second calculated using since uptime - rps or tps
sum(prometheus_http_request_duration_seconds_count) / sum(prometheus_http_request_duration_seconds_sum)
399

## Calculated over last 10 minutes - rps or tps
sum(rate(prometheus_http_request_duration_seconds_count[10m])) / sum(rate(prometheus_http_request_duration_seconds_sum[10m]))
400

## seconds per transaction OR seconds per request
sum(rate(prometheus_http_request_duration_seconds_sum[10m])) / sum(rate(prometheus_http_request_duration_seconds_count[10m]))
0.003
## Seconds per request since uptime
sum(prometheus_http_request_duration_seconds_sum) / sum(prometheus_http_request_duration_seconds_count)
0.002

# Latency - Bucket Distribution

## Requests in buckets (cumulative)
sum by (le) (prometheus_http_request_duration_seconds_bucket)

# Error Rate - rps
sum(rate(prometheus_http_requests_total{code!="200"}[5m]))
0.01

## Time (s) taken by 90% percentile of requests
histogram_quantile(0.9, sum by (le) (rate(prometheus_http_request_duration_seconds_bucket[10m])))
0.09

