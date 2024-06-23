# CPU usage by all nodes
(1 - avg(irate(node_cpu_seconds_total{mode="idle"}[10m])) by (instance)) * 100

# % memory usage  by all nodes
100 * (1-((avg_over_time(node_memory_MemFree_bytes[10m])+avg_over_time(node_memory_Cached_bytes[10m])+avg_over_time(node_memory_Buffers_bytes[10m]))/avg_over_time(node_memory_MemTotal_bytes[10m])))

