#!/usr/bin/env sh

# Create the cache-endpoint secret on K8s cluster (--namespace ck8s-prod)
kubectl create secret generic cache-endpoint --from-file=file=cache-endpoint.secret -n ck8s-prod > /dev/null

# Create the cache-password secret on K8s cluster (--namespace ck8s-prod)
kubectl create secret generic cache-password --from-file=file=cache-password.secret -n ck8s-prod > /dev/null

echo "docker-compose external secrets [cache-endpoint] & [cache-password] have been created."