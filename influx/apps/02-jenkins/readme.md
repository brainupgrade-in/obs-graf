# Queries
## Success ratio guage
import "influxdata/influxdb/v1"
import "strings"

from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
    |> filter(fn: (r) => 
      if v.jenkinsJobNames == "<all>" then true
      else if v.jenkinsJobNames == "<without excluded>" then not contains(set: strings.split(v: v.jenkinsExcludedJobs, t: ","), value: r.name)
      else r.name == v.jenkinsJobNames
    )
  |> v1.fieldsAsCols()
  |> duplicate(column: "result_code", as: "_value")
  |> group()
  |> reduce(
       fn: (r, accumulator) => ({
            total: accumulator.total + 1,
            success: accumulator.success + (if r.result_code == 0 then 1 else 0),
        }),
        identity: {total: 0, success: 0}
    )  
   |> map(fn: (r) => ({r with _value: (float(v: 100 * r.success) / float(v: r.total))}))

## Projects - stat
import "influxdata/influxdb/v1"
import "strings"

from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => 
      if v.jenkinsJobNames == "<all>" then true
      else if v.jenkinsJobNames == "<without excluded>" then not contains(set: strings.split(v: v.jenkinsExcludedJobs, t: ","), value: r.name)
      else r.name == v.jenkinsJobNames
    )
  |> v1.fieldsAsCols()
  |> duplicate(column: "result_code", as: "_value")
  |> group()
  |> distinct(column: "name")
  |> count()

## Successful Builds - stat
import "influxdata/influxdb/v1"
import "strings"

from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => 
      if v.jenkinsJobNames == "<all>" then true
      else if v.jenkinsJobNames == "<without excluded>" then not contains(set: strings.split(v: v.jenkinsExcludedJobs, t: ","), value: r.name)
      else r.name == v.jenkinsJobNames
    )
  |> v1.fieldsAsCols()
  |> filter(fn: (r) => r.result_code == 0)
  |> duplicate(column: "result_code", as: "_value")
  |> group()
  |> count()


## Last Build - table

import "influxdata/influxdb/v1"
import "strings"

from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => 
      if v.jenkinsJobNames == "<all>" then true
      else if v.jenkinsJobNames == "<without excluded>" then not contains(set: strings.split(v: v.jenkinsExcludedJobs, t: ","), value: r.name)
      else r.name == v.jenkinsJobNames
    )
  |> v1.fieldsAsCols()
  |> duplicate(column: "result_code", as: "_value")
  |> group()
  |> keep(columns: ["_time", "host", "port", "name", "result", "result_code", "duration"])
  |> map(fn: (r) => ({r with link: "https://" + r.host + ":" + r.port + "/job/" + r.name + "/"}))

## Success Rate - Last 7 days TAble
import "influxdata/influxdb/v1"
import "strings"

from(bucket: v.jenkinsBucket)
  |> range(start: -1w)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => 
      if v.jenkinsJobNames == "<all>" then true
      else if v.jenkinsJobNames == "<without excluded>" then not contains(set: strings.split(v: v.jenkinsExcludedJobs, t: ","), value: r.name)
      else r.name == v.jenkinsJobNames
    )
  |> v1.fieldsAsCols()
  |> duplicate(column: "result_code", as: "_value")
  |> group(columns: ["name"])
  |> reduce(
       fn: (r, accumulator) => ({
            total: accumulator.total + 1,
            success: accumulator.success + (if r.result_code == 0 then 1 else 0),
        }),
        identity: {total: 0, success: 0}
    )  
   |> map(fn: (r) => ({r with _value: (float(v: 100 * r.success) / float(v: r.total))}))
   |> group()

## Job Duration - chart
from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r._field == "duration")
  |> filter(fn: (r) => r.result == "SUCCESS")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> group(columns: ["name"])
  |> map(fn: (r) => ({
    r with
    _value: r._value / 1000
  }))

  ## Recent failed job
  from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r._field == "result_code")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => r.result == "FAILURE")
  |> group(columns: ["result"])
  |> sort(columns: ["_time"])
  |> last()
  |> drop(columns: ["_value"])
  |> rename(columns: {name: "_value"})
  |> yield(name: "sort")

  # Recent Successful Job
  from(bucket: v.jenkinsBucket)
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "jenkins_job")
  |> filter(fn: (r) => r._field == "result_code")
  |> filter(fn: (r) => r.host == v.jenkinsHostnames)
  |> filter(fn: (r) => r.result == "SUCCESS")
  |> group(columns: ["result"])
  |> sort(columns: ["_time"])
  |> last()
  |> drop(columns: ["_value"])
  |> rename(columns: {name: "_value"})
  |> yield(name: "sort")
  
# Dashboard
## InfluxDB - Settings - template
https://raw.githubusercontent.com/influxdata/community-templates/master/jenkins/jenkins.yml