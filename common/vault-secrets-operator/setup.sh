#!/bin/bash -xe
export CLUSTER_NAME=$1
kubens vault-secrets-operator
export VAULT_SECRETS_OPERATOR_NAMESPACE=$(kubectl get sa vault-secrets-operator -o jsonpath="{.metadata.namespace}")
# export VAULT_SECRET_NAME=$(kubectl get sa vault-secrets-operator -o jsonpath="{.secrets[*]['name']}")
export VAULT_SECRET_NAME="vault-secrets-operator"
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SECRET_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret $VAULT_SECRET_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_HOST=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

# Verify the environment variables
env | grep -E 'VAULT_SECRETS_OPERATOR_NAMESPACE|VAULT_SECRET_NAME|SA_JWT_TOKEN|SA_CA_CRT|K8S_HOST'
# Enable the Kubernetes auth method at the default path (auth/kubernetes) and finish the configuration of Vault:

vault auth enable -path=k8s-${CLUSTER_NAME} kubernetes || true

# Tell Vault how to communicate with the Kubernetes cluster
vault write auth/k8s-${CLUSTER_NAME}/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="$K8S_HOST" \
  kubernetes_ca_cert="$SA_CA_CRT" \
  disable_iss_validation="true"

# Create a role named, 'vault-secrets-operator' to map Kubernetes Service Account to Vault policies and default token TTL
vault write auth/k8s-${CLUSTER_NAME}/role/vault-secrets-operator \
  bound_service_account_names="vault-secrets-operator" \
  bound_service_account_namespaces="$VAULT_SECRETS_OPERATOR_NAMESPACE" \
  policies=vault-secrets-operator \
  ttl=24h
