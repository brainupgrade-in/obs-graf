#!/bin/bash

APP_URL=$1

curl --request GET \
  --url http://$APP_URL/ \
  --header 'traceparent: 00-ab123039b602c93e641526aaa7d67b8c-129f2b7a83c7d606-01'

curl --request POST \
  --url http://$APP_URL/peanuts \
  --header 'content-type: application/json' \
  --data '{"name": "IND", "description": "India" }'

curl --request POST \
  --url http://$APP_URL/peanuts \
  --header 'content-type: application/json' \
  --data '{"name": "Woodstock", "description": "A cute bird" }'

curl --request POST \
  --url http://$APP_URL/peanuts \
  --header 'content-type: application/json' \
  --data '{"name": "City","description": "IT'\''s lead"}'

curl --request GET \
  --url http://$APP_URL/peanuts/1

curl --request GET \
  --url http://$APP_URL/peanuts/1

curl --request GET \
  --url http://$APP_URL/peanuts/2

curl --request GET \
  --url http://$APP_URL/peanuts/2

curl --request GET \
  --url http://$APP_URL/peanuts/3

curl --request GET \
  --url http://$APP_URL/peanuts/3