FROM ubuntu:24.10

LABEL Author="info@brainupgrade.in"

RUN apt-get update && apt-get install -y wget vim tmux
WORKDIR /opt
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.55.1/prometheus-2.55.1.linux-amd64.tar.gz
RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-11.3.0.linux-amd64.tar.gz

CMD [ "tail","-f","/dev/null" ]

# docker build -t brainupgrade/ubuntu-obs:2.55.1-11.3.0 -t brainupgrade/ubuntu-obs:latest .
# docker push brainupgrade/ubuntu-obs:2.55.1-11.3.0