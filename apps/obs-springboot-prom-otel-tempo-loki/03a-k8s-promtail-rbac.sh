#!/bin/bash

# for i in {1..1};do ./04-k8s-promtail-rbac.sh  mtvlabk8su$i ; done
namespace=$1

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: promtail-${namespace}
  namespace: ${namespace}
subjects:
- kind: ServiceAccount
  name: promtail-${namespace}
  namespace: ${namespace}
roleRef:
  kind: ClusterRole
  name: promtail-mtvlabk8s
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: promtail-mtvlabk8s
rules:
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs:
  - get
  - watch
  - list
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: promtail-${namespace}
  namespace: ${namespace}
EOF