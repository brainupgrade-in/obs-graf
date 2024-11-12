# Launch weather app
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/apps/weather/weather.yaml

# Ingress Update

kubectl patch ingress <user>-app.brainupgrade.in --type=json  -p='[{"op":"replace","path":"/spec/rules/0/http/paths/0/backend/service/name","value":"weather-front"}]'