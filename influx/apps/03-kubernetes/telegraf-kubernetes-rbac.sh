#!/bin/bash

# for i in {1..1};do ./telegraf-kubernetes-rbac.sh  mtvlabk8su$i ; done
namespace=$1

cat <<EOF | kubectl apply -f -

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: telegraf-kubernetes-${namespace}
  namespace: ${namespace}
subjects:
- kind: ServiceAccount
  name: telegraf-kubernetes
  namespace: ${namespace}
roleRef:
  kind: ClusterRole
  name: view
  apiGroup: rbac.authorization.k8s.io

EOF