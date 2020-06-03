#!/usr/bin/env sh

docker stack rm --kubeconfig ~/.kube/config --namespace es-stack-external --orchestrator kubernetes es-stack-external
sleep 5
kubectl delete ns es-stack-external