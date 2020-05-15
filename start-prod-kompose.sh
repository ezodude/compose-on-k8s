#!/usr/bin/env sh

kubectl create namespace ck8s-kompose-prod
kubectl apply \
  -f kompose-manifests/prod/cache-endpoint-secret.yaml \
  -f kompose-manifests/prod/cache-password-secret.yaml \
  -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/prod-secrets-configmap.yaml -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/prod-esnet-networkpolicy.yaml -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/backend-deployment.yaml -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/frontend-deployment.yaml -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/missing-backend-service.yaml -n ck8s-kompose-prod
kubectl apply -f kompose-manifests/prod/frontend-service.yaml -n ck8s-kompose-prod
kubectl get pods -n ck8s-kompose-prod
