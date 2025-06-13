# Setup grafana smtp
## Create the secret
kubectl create secret generic grafana-smtp-secret  --from-literal=smtp-secret=''
## set grafana env
kubectl set env sts/grafana \
  GF_SMTP_ENABLED=true \
  GF_SMTP_HOST="linux811.hostguy.com:465" \
  GF_SMTP_USER="grafana@brainupgrade.in" \
  GF_SMTP_FROM_ADDRESS="grafana@brainupgrade.in" \
  GF_SMTP_FROM_NAME="Grafana Alerts" \
  GF_SMTP_SKIP_VERIFY=true \
  GF_SMTP_STARTTLS_POLICY=NoStartTLS

## update secret fetching
kubectl patch sts grafana \
  --type='json' \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/env/-", "value": {"name": "GF_SMTP_PASSWORD", "valueFrom": {"secretKeyRef": {"name": "grafana-smtp-secret", "key": "smtp-secret"}}}}]'


kubectl set env sts grafana  GF_SERVER_ROOT_URL=https://mtvlabeksu30-obs.brainupgrade.in
