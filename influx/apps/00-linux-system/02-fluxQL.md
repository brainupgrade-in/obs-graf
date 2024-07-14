
# System Uptime
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "system")
  |> filter(fn: (r) => r._field == "uptime")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> last()
  |> map(fn: (r) => ({ _value: float(v: r._value) / 86400.00 }))

# nCPUs
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "system")
  |> filter(fn: (r) => r._field == "n_cpus")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> last()

# System Load
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "system")
  |> filter(fn: (r) => r._field == "load1")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> last()
# Total Memory
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "mem")  
  |> filter(fn: (r) => r._field == "total")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> last()  
  |> map(fn: (r) => ({r with _value: float(v: r._value) / 1024.0 / 1024.0 / 1024.0}))
#  Memory Usage
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "mem")
  |> filter(fn: (r) => r._field == "used_percent")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
# Disk Usage
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "disk")
  |> filter(fn: (r) => r._field == "used_percent")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
# CPU Usage
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "cpu")
  |> filter(fn: (r) => r._field == "usage_user" or r._field == "usage_system" or r._field == "usage_idle")
  |> filter(fn: (r) => r.cpu == "cpu-total")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
# System Load
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "system")
  |> filter(fn: (r) => r._field == "load1" or r._field == "load5" or r._field == "load15")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
# Disk IO
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "diskio")
  |> filter(fn: (r) => r._field == "read_bytes" or r._field == "write_bytes")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> derivative(unit: v.windowPeriod, nonNegative: false)
# Network
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "net")
  |> filter(fn: (r) => r._field == "bytes_recv" or r._field == "bytes_sent")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> derivative(unit: v.windowPeriod, nonNegative: false)
# Processes
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "processes")
  |> filter(fn: (r) => r._field == "running" or r._field == "blocked" or r._field == "idle" or r._field == "unknown")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: max)
# Swap
from(bucket: "${bucket}")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "swap")
  |> filter(fn: (r) => r._field == "total" or r._field == "used")
  |> filter(fn: (r) => r.host == "${linux_host}")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)

# Reference
https://raw.githubusercontent.com/influxdata/community-templates/master/linux_system/linux_system.yml