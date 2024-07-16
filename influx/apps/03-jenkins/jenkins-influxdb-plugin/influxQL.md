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