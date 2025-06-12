| **Metric Type** | **Metric Name**                                   | **Notes**                                                                                  |
| --------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Counter**     | `prometheus_http_requests_total`                  | Classic example that only increases (requests processed). Ideal for demonstrating `rate()` and `increase()`. |
|                 | `go_memstats_mallocs_total`                       | Shows memory allocations over time—good for usage over application lifecycle.                                |
| **Gauge**       | `process_resident_memory_bytes`                   | Instantaneous memory usage, clearly fluctuates—ideal to explain real-time value changes.                     |
|                 | `go_goroutines`                                   | Number of goroutines; can increase/decrease—ideal for explaining gauges.                                     |
| **Histogram**   | `prometheus_http_request_duration_seconds_bucket` | Perfect for latency distribution demo. Bucketed values + `_sum` and `_count`.                                |
|                 | `go_gc_heap_allocs_by_size_bytes_bucket`          | Great for showing how object size allocations are bucketed.                                                  |
| **Summary**     | `go_gc_duration_seconds`                          | Shows quantiles (0.5, 0.9, 1.0), `_sum`, and `_count`—ideal for teaching summaries.                          |
|                 | `prometheus_engine_query_duration_seconds`        | Summarizes query latencies in Prometheus engine. Useful for dashboarding and alert thresholds.               |

---
| **Function**           | **Use This Metric**                                         | **How to Use It**                                                                       |
| ---------------------- | ----------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `rate()`               | `prometheus_http_requests_total`                            | `rate(prometheus_http_requests_total[5m])` – explains per-second rate over time.        |
| `irate()`              | `prometheus_http_requests_total`                            | `irate(prometheus_http_requests_total[1m])` – perfect to show latest spike patterns.    |
| `increase()`           | `go_gc_cycles_total_gc_cycles_total`                        | `increase(go_gc_cycles_total_gc_cycles_total[1h])` – helps explain growth over a range. |
| `sum()`                | `go_memstats_heap_alloc_bytes`                              | `sum(go_memstats_heap_alloc_bytes)` – demonstrates aggregation across instances.        |
| `avg()`                | `prometheus_engine_query_duration_seconds_sum` and `_count` | `avg = sum() / count()` – teach custom averaging using summary parts.                   |
| `histogram_quantile()` | `prometheus_http_request_duration_seconds_bucket`           | Advanced use: `histogram_quantile(0.95, rate(...[5m]))` – illustrates p95 latency.      |
---
# Basic examples
## Counter with rate
rate(prometheus_http_requests_total[1m])
## Memory Gauge
process_resident_memory_bytes
## Histogram Buckets + Quantile
histogram_quantile(0.95, rate(prometheus_http_request_duration_seconds_bucket[5m]))
## Summary Breakdown
rate(go_gc_duration_seconds_sum[5m]) / rate(go_gc_duration_seconds_count[5m])
---
| **Query**                                                                             | **Purpose**              |
| ------------------------------------------------------------------------------------- | ------------------------ |
| `rate(prometheus_http_requests_total[5m])`                                            | Per-second request rate  |
| `increase(prometheus_http_requests_total[1h])`                                        | Total requests in 1 hour |
| `sum(rate(prometheus_http_requests_total[1m]))`                                       | Combined request rate    |
| `histogram_quantile(0.99, rate(prometheus_http_request_duration_seconds_bucket[5m]))` | 99th percentile latency  |
| `avg(go_memstats_alloc_bytes)`                                                        | Avg heap allocation      |
| `delta(process_cpu_seconds_total[10m])`                                               | CPU usage delta          |
---
# Advanced Examples
## Group by HTTP Response code
increase(prometheus_http_requests_total{code!~"2.."}[5m])
## Group by end  point
increase(prometheus_http_requests_total[5m]) by handler