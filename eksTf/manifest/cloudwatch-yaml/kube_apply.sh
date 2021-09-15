
#/bin/bash

kubectl apply -f cloudwatch-namespace.yaml


kubectl apply -f cwagent-serviceaccount.yaml


EKS_CLUSTER_NAME=eks-work-cluster envsubst < cwagent-configmap.yaml | kubectl apply -f -

kubectl apply -f cwagent-daemonset.yaml
