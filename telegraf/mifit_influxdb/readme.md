kubectl create secret generic zepp \
--from-literal='email=xxx@gmail.com' \
--from-literal='pass=aaa'

kubectl create secret generic influxdb \
--from-literal=influxdb_token='token' \
--from-literal=influxdb_org='DevTeam' \
--from-literal=influxdb_url='https://us-east-1-1.aws.cloud2.influxdata.com'