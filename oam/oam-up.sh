#!/usr/bin/env sh

kubectl create namespace es-oam-prod

kubectl create secret generic cache-endpoint \
--from-file=cache-endpoint-secret=cache-endpoint.secret -n es-oam-prod

kubectl create secret generic cache-password \
--from-file=cache-password-secret=cache-password.secret -n es-oam-prod

kubectl get secrets -n es-oam-prod

kubectl apply -f oam/components.yaml -n es-oam-prod
kubectl apply -f oam/appconfig.yaml -n es-oam-prod

#kubectl port-forward deployment/frontend 8080
sleep 5
kubectl get pods -n es-oam-prod
