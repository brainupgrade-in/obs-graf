# Ingress setup

kubectl annotate ingress app     nginx.ingress.kubernetes.io/rewrite-target="/\$1"  nginx.ingress.kubernetes.io/use-regex="true"