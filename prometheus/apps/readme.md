# Ingress setup

kubectl create ingress -n weather  mtvlabk8s-weather.brainupgrade.in --rule="mtvlabk8s-weather.brainupgrade.in/?(.*)=weather-front:80,tls=weahr8sec" --class nginx --annotation=cert-manager.io/cluster-issuer=letsencrypt-prod

kubectl annotate ingress mtvlabk8s-weather.brainupgrade.in  -n weather   nginx.ingress.kubernetes.io/rewrite-target="/\$1"  nginx.ingress.kubernetes.io/use-regex="true"