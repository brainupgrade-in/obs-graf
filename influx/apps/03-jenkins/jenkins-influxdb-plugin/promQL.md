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
