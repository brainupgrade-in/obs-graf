# InfluxQL
## Uptime in %
SELECT (1 - mean("usage_idle") / 100) * 100 AS "uptime_percentage"
FROM "cpu"
WHERE time > now() - 30d
GROUP BY time(1d)

## Resource Utilization Efficiency
SELECT mean("usage_user") AS "avg_cpu_usage", mean("used") / mean("total") * 100 AS "avg_memory_usage"
FROM "cpu", "mem"
WHERE time > now() - 7d
GROUP BY time(1d)


## Monitor CPU Usage (Time Series)

SELECT mean("usage_user") AS "user", mean("usage_system") AS "system", mean("usage_idle") AS "idle"
FROM "cpu"
WHERE time > now() - 1h
GROUP BY time(5m)

## Memory Usage (Time Series - bytes)
SELECT mean("free") AS "free_memory", mean("used") AS "used_memory", mean("cached") AS "cached_memory"
FROM "mem"
WHERE time > now() - 24h
GROUP BY time(30m)

## Disk IO Monitoring (Time Series - bytes)
SELECT sum("read_bytes") AS "read_bytes", sum("write_bytes") AS "write_bytes"
FROM "diskio"
WHERE time > now() - 6h
GROUP BY time(10m)


## CPU Usage Rate of Change
SELECT DERIVATIVE(mean("usage_system"), 1s) AS "system_usage_rate", DERIVATIVE(mean("usage_user"), 1s) AS "user_usage_rate"
FROM "cpu"
WHERE time > now() - 1h
GROUP BY time(1m)

##  Network Throughput Rate of Change
SELECT DERIVATIVE(mean("bytes_sent"), 1s) AS "sent_rate", DERIVATIVE(mean("bytes_received"), 1s) AS "received_rate"
FROM "net"
WHERE time > now() - 1h
GROUP BY time(1m)



# Template query: 
SHOW TAG VALUES FROM "cpu" WITH KEY = "$tagkey"

# Misc
SHOW DATABASES (/measurements)

SHOW TAG KEYS FROM cpu

SHOW FIELD KEYS FROM cpu

SHOW TAG VALUES FROM "cpu" WITH KEY = "host"


SELECT usage_idle FROM cpu WHERE time > now() - 1h ORDER BY time DESC

# TODO
SELECT usage_idle FROM cpu WHERE time > now() - 1h

SELECT COUNT(usage_idle) FROM cpu WHERE time > now() - 1h

SELECT MEAN(usage_idle) FROM cpu WHERE time > now() - 1h GROUP BY host

SELECT MEAN(usage_idle) FROM cpu WHERE time > now() - 1h GROUP BY time(10m)

## Rate of change
SELECT DERIVATIVE(mean("usage_idle"), 1s) FROM cpu WHERE time > now() - 1h GROUP BY time(10m)  


SELECT mean("usage_user") FROM "cpu" WHERE "host" =~ /^$host$/ AND $timeFilter GROUP BY time($__interval) fill(null)

SELECT usage_idle FROM cpu WHERE time > now() - 1h AND host =~ /^$host$/

SELECT * FROM cpu WHERE  $timeFilter AND host =~ /^$host$/
