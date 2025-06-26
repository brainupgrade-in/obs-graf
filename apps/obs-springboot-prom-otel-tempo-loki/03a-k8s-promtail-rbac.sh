#!/bin/bash

# for i in {1..30};do ./03a-k8s-promtail-rbac.sh  mtvlabeksu$i ; done
namespace=$1

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: promtail-${namespace}
  namespace: ${namespace}
subjects:
- kind: ServiceAccount
  name: promtail
  namespace: ${namespace}
roleRef:
  kind: ClusterRole
  name: promtail
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: promtail
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
  name: promtail
  namespace: ${namespace}
EOF