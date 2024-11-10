# Set up for exporter
kubectl exec -it deploy/mariadb -- bash
mysql -u root -p 
create user 'exporter'@'localhost' identified by 'exporter' with max_user_connections 3;
grant process, replication client, select on *.* to 'exporter'@'localhost';

exit

cd /opt
tar xvzf 

echo "[client]">>.my.cnf
echo "user=exporter">>.my.cnf
echo "password=exporter">>.my.cnf

./mysqld_exporter & 

# Update prometheus.yml
    - job_name: mysql # To get metrics about the mysql exporter’s targets
      static_configs:
        - targets:
          - mariadb:3306
          - unix:///run/mysqld/mysqld.sock
      relabel_configs:
        - source_labels: [__address__]
          target_label: __param_target
        - source_labels: [__param_target]
          target_label: instance
        - target_label: __address__
          # The mysqld_exporter host:port
          replacement: mariadb:9104
# mysql prom QL
mysql_version_info

# Grafana Dashboard
14057