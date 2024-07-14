SELECT usage_idle FROM cpu WHERE time > now() - 1h

SELECT COUNT(usage_idle) FROM cpu WHERE time > now() - 1h

SELECT MEAN(usage_idle) FROM cpu WHERE time > now() - 1h GROUP BY host

SELECT MEAN(usage_idle) FROM cpu WHERE time > now() - 1h GROUP BY time(10m)

SELECT usage_idle FROM cpu WHERE time > now() - 1h ORDER BY time DESC

SELECT DERIVATIVE(mean("usage_idle"), 1s) FROM cpu WHERE time > now() - 1h GROUP BY time(10m)  (rate of change)

SHOW DATABASES (/measurements)

SHOW TAG KEYS FROM cpu

SHOW FIELD KEYS FROM cpu

SHOW TAG VALUES FROM "cpu" WITH KEY = "host"

SELECT mean("usage_user") FROM "cpu" WHERE "host" =~ /^$host$/ AND $timeFilter GROUP BY time($__interval) fill(null)

SELECT usage_idle FROM cpu WHERE time > now() - 1h AND host =~ /^$host$/

SELECT * FROM cpu WHERE  $timeFilter AND host =~ /^$host$/

Template query: SHOW TAG VALUES FROM "cpu" WITH KEY = "$tagkey"
