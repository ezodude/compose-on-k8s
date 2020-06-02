#!/usr/bin/env sh

# Install Crossplane
kubectl create namespace crossplane-system
helm repo add crossplane-alpha https://charts.crossplane.io/alpha

# Kubernetes 1.15 and newer versions
helm install crossplane --namespace crossplane-system crossplane-alpha/crossplane

# OAM
kubectl apply -f https://raw.githubusercontent.com/crossplane/crossplane/release-0.11/docs/snippets/run/definitions.yaml
## Crossplane OAM Addon
helm install addon-oam-kubernetes-local --namespace crossplane-system crossplane-alpha/oam-core-resources