# Queries

## Agent - Metrics Gathered (single stat)
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_agent")
                  |> filter(fn: (r) => r._field == "metrics_gathered")

        name: Agent - Metrics gathered or written per second - Xy
                import "experimental/aggregate"
                  from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_agent")
                  |> filter(fn: (r) => r._field == "metrics_gathered" or r._field == "metrics_written")
                  |> aggregate.rate(every: v.windowPeriod, unit: 1s, groupColumns: ["_field"])                  


Inputs - metrics gathered per input  - Xy
                import "experimental/aggregate"
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_gather")
                  |> filter(fn: (r) => r._field == "metrics_gathered")
                  |> derivative(unit: v.windowPeriod, nonNegative: true, columns: ["_value"], timeColumn: "_time")
                  |> aggregateWindow(every: duration(v: int(v: v.windowPeriod) * 6), fn: sum)


Output - Write buffer size Xy
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_write")
                  |> filter(fn: (r) => r._field == "buffer_size")
                  |> aggregateWindow(every: v.windowPeriod, fn: max)


memory allocations Xy
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_memstats")
                  |> filter(fn: (r) => r._field == "mallocs")
                  |> derivative(unit: v.windowPeriod, nonNegative: true)
                  |> yield(name: "nonnegative derivative")

Agent - Metrics Written sstat
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_agent")
                  |> filter(fn: (r) => r._field == "metrics_written")

Agent - input plugin errors xy
                import "experimental/aggregate"
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_agent")
                  |> filter(fn: (r) => r._field == "gather_errors")
                  |> group()
                  |> aggregateWindow(every: v.windowPeriod, fn: sum)
                  |> derivative(unit: v.windowPeriod, nonNegative: true, columns: ["_value"], timeColumn: "_time")

Inputs - Errors per input xy
                import "experimental/aggregate"
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_gather")
                  |> filter(fn: (r) => r._field == "errors")
                  |> aggregateWindow(every: v.windowPeriod, fn: sum)
                  |> derivative(unit: v.windowPeriod, nonNegative: true, columns: ["_value"], timeColumn: "_time")

Garbage Collection xy
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_memstats")
                  |> filter(fn: (r) => r._field == "num_gc")
                  |> derivative(unit: v.windowPeriod, nonNegative: true)
                  |> yield(name: "nonnegative derivative")

Inputs - Time to gather metrics xy
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_gather")
                  |> filter(fn: (r) => r._field == "gather_time_ns")
                  |> map(fn: (r) => ({ r with _value: r._value / 1000000 }))
                  |> aggregateWindow(every: v.windowPeriod, fn: max)

Heap Memory in use xy
                from(bucket: "Telegraf")
                  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
                  |> filter(fn: (r) => r._measurement == "internal_memstats")
                  |> filter(fn: (r) => r._field == "heap_in_use_bytes")



# Dashboard
## InfluxDB - Settings - template
https://raw.githubusercontent.com/influxdata/community-templates/master/telegraf/manifest.yml