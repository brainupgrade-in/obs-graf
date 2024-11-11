# Dashboard queries

## Uptime - stats (unit - seconds)
process_uptime_seconds{application="$application", instance="$instance"}

## Starttime - stats (unit -datetime ISO)
process_start_time_seconds{application="$application", instance="$instance"}*1000

## CPU Usage - Time Series (unit - percent 0 to 1)
system_cpu_usage{instance="$instance", application="$application"}

process_cpu_usage{instance="$instance", application="$application"}

## System Load average - Time Series
system_load_average_1m{instance="$instance", application="$application"}

system_cpu_count{instance="$instance", application="$application"}

## Requests served since start time - Stat (graph - none, legend {{uri}})
http_server_requests_seconds_count{instance="$instance", application="$application"}

## RPS - Requests per second - Load on the system - Time Series (legend {{uri}})
<!-- http_server_requests_seconds_count{instance="$instance", application="$application"} -->

rate(http_server_requests_seconds_count{instance="$instance", application="$application"}[$__rate_interval])

## Heap Used - stats (no graph, unit - percent 0-100)

sum(jvm_memory_used_bytes{application="$application", instance="$instance", area="heap"})*100/sum(jvm_memory_max_bytes{application="$application",instance="$instance", area="heap"})

## JVM Memory Usage 
jvm_memory_used_bytes{instance="app:80"}  - legend {{id}},{{area}}

sum(jvm_memory_max_bytes{instance="app:80"})

## JVM Heap Usage - Time Series (units - bytes IEC)
sum(jvm_memory_used_bytes{application="$application", instance="$instance", area="heap"})

sum(jvm_memory_committed_bytes{application="$application", instance="$instance", area="heap"})

sum(jvm_memory_max_bytes{application="$application", instance="$instance", area="heap"})

## GC Pause Duration - Time Series
rate(jvm_gc_pause_seconds_sum{application="$application", instance="$instance"}[1m])/rate(jvm_gc_pause_seconds_count{application="$application", instance="$instance"}[1m])

## File Descriptors - Time Series
process_files_open_files{application="$application", instance="$instance"}

process_files_max_files{application="$application", instance="$instance"}

## Thread states - Time Series
jvm_threads_states_threads{application="$application", instance="$instance"}
