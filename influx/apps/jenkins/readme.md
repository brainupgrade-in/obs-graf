# Deploy Jenkins
    kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/dockerk8s/main/kubernetes/lab/07-statefulset/jenkins/jenkins.yaml
## Enable prometheus metrics scrapping
    kubectl apply -n jenkins -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/main/prometheus/ks8-discovery/jenkins-prometheus-service.yaml

# Enable Prometheus to scrape apps with svc annotation
    kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/main/prometheus/ks8-discovery/k8s-prometheus-configmap-svc-annotation.yaml
    kubectl set sa sts/prometheus prometheus
    kubectl rollout restart sts prometheus

# Login into jenkins and add plugin influxdb and configure
    bucket jenkins
    URL  influxdb.<namespace>.svc:8086
    token
    org org

# Add InfluxDB datasource to grafana
## InfluxQL
    http://influxdb:8086
    org org
    bucket jenkins
    Header Name: Authorization
    Header value: Token <token>
## FlexQL
    http://influxdb:8086
    org org
    bucket jenkins
    token <token>

# Grafana Dashboard

## InfluxQL 
select * from agent_data;
select * from jenkins_data; 

### Build Duration Over Time
SELECT mean("build_time") 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY time($interval)

### Total Number of Builds
SELECT count("build_number") 
FROM "jenkins_data" 

### Total Number of builds over Time
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY time($interval)

### Successful Builds
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE "build_result"='SUCCESS' AND $timeFilter 

### Failed Builds
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE "build_result"='FAILURE' AND $timeFilter 

### Number of builds per job
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY "project_name"

### Build duration per job

SELECT ("build_time") 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY "project_name"


### Build Failures Over Time
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE "build_result"='FAILURE' AND $timeFilter 
GROUP BY time($interval)

### Success vs Failure
SELECT count("build_number") 
FROM "jenkins_data" 
WHERE "build_result"='SUCCESS' OR "build_result"='FAILURE' AND $timeFilter 
GROUP BY "build_result"

### Build duration Percentile
SELECT percentile("build_time", 95) 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY project_name

### Avg Wait Time
SELECT mean("time_in_queue") 
FROM "jenkins_data" 
WHERE $timeFilter 
GROUP BY project_name

## Prom Queries
    Total Jenkins Health: jenkins_health_check_score{instance=~".+"}
    Total CPU Usage: vm_cpu_load{instance=~".+"}
    Total Memory Usage: vm_memory_total_used{}
    Total JVM Heap Usage: (jvm_memory_bytes_used{area="heap"}) / jvm_memory_bytes_max{area="heap"} * 100
    Offline Nodes: sum(jenkins_node_offline_value{})
    Total Jobs: sum(jenkins_job_count_value{})  
    Total Queue size: sum(jenkins_queue_size_value{})
    Successful Jobs (last 24 hrs): sum(floor(increase(jenkins_runs_success_total{}[24h])))
    Failed Jobs (last 24 hrs): sum(floor(increase(jenkins_runs_failure_total{}[24h])))
    Free executors: sum(jenkins_executor_free_value{})
    Executors in use: sum(jenkins_executor_in_use_value{})
    Aborted jobs (last 24 hrs): sum(floor(increase(jenkins_runs_aborted_total{}[24h])))
    Unstable jobs (last 24 hrs): sum(floor(increase(jenkins_runs_unstable_total{}[24h])))
    Jobs queue duration (quantile 0.999): jenkins_job_queuing_duration{quantile="0.999"}
    Successful Jobs: sum(jenkins_runs_success_total{})
    Offline Jenkins nodes: jenkins_node_offline_value{instance=~".+"}
    Queue size: jenkins_queue_size_value{instance=~".+"}


## Jenkins Monitoring (14550)
Ref: https://grafana.com/grafana/dashboards/14550-jenkins-monitoring/