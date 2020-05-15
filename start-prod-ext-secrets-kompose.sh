#!/usr/bin/env sh

kubectl create namespace ck8s-kompose-prod-ext

kubectl create secret generic cache-endpoint \
--from-file=cache-endpoint=cache-endpoint.secret -n ck8s-kompose-prod-ext

kubectl create secret generic cache-password \
--from-file=cache-password=cache-password.secret -n ck8s-kompose-prod-ext

kubectl get secrets -n ck8s-kompose-prod-ext

kubectl apply -f kompose-manifests/prod-external-secrets/prod-secrets-configmap.yaml -n ck8s-kompose-prod-ext
kubectl apply -f kompose-manifests/prod-external-secrets/prod-esnet-networkpolicy.yaml -n ck8s-kompose-prod-ext
kubectl apply -f kompose-manifests/prod-external-secrets/backend-deployment.yaml -n ck8s-kompose-prod-ext
kubectl apply -f kompose-manifests/prod-external-secrets/frontend-deployment.yaml -n ck8s-kompose-prod-ext
kubectl apply -f kompose-manifests/prod-external-secrets/missing-backend-service.yaml -n ck8s-kompose-prod-ext
kubectl apply -f kompose-manifests/prod-external-secrets/frontend-service.yaml -n ck8s-kompose-prod-ext
kubectl get pods -n ck8s-kompose-prod-ext
