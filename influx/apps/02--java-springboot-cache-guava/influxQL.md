# Uptime (Stat - ms)
SELECT last("value") FROM "process_uptime" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/) AND $timeFilter GROUP BY time($__interval) fill(null)

# Start Time (Stat - Datetime ISO)
SELECT mean("value") FROM "process_start_time" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/) AND $timeFilter GROUP BY time($__interval) fill(null)

# Heap Used (Stat)
SELECT mean("value")  / 1024/1024 FROM "jvm_memory_used" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/ AND "area"::tag = 'heap') AND $timeFilter GROUP BY time(5s) fill(null) ORDER BY time DESC

# JVM Memory (Time Series - Megabytes)
SELECT sum("value")  / 1024/1024 FROM "jvm_memory_used" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/) AND $timeFilter GROUP BY time($__interval) fill(null)

SELECT sum("value")  / 1024/1024 FROM "jvm_memory_max" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/) AND $timeFilter GROUP BY time($__interval) fill(null)

SELECT sum("value")  / 1024/1024 FROM "jvm_memory_committed" WHERE ("application"::tag =~ /^$Application$/ AND "environment"::tag =~ /^$Environment$/) AND $timeFilter GROUP BY time($__interval) fill(null)



# Dashboard Template Variables
Application: SHOW TAG VALUES WITH KEY = "application"
Environment: SHOW TAG VALUES WITH KEY = "environment"