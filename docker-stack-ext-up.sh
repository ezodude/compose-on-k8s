#!/usr/bin/env sh

kubectl create ns es-stack-external

kubectl create secret generic cache-endpoint \
--from-file=file=cache-endpoint.secret -n es-stack-external

kubectl create secret generic cache-password \
--from-file=file=cache-password.secret -n es-stack-external

docker stack deploy -c docker-compose.yml -c docker-compose.prod.external-secrets.yml --kubeconfig ~/.kube/config --namespace es-stack-external --orchestrator kubernetes es-stack-external