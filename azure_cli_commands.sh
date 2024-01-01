#!/bin/bash

# Set your Azure subscription and resource group
SUBSCRIPTION_ID="aa26d19c-f10a-4711-89ae-0293c48bb8bd"
RESOURCE_GROUP="rgpythonapp"

az ad sp create-for-rbac --name "myapp" --role contributor --scopes /subscriptions/aa26d19c-f10a-4711-89ae-0293c48bb8bd/resourceGroups/rgpythonapp --json-auth

# Set your service principal details
SP_NAME="myapp"
# SP_SECRET=$(az ad sp credential reset --name $SP_NAME --query "password" --output tsv)
az ad sp credential reset --name "myapp" --credential-description "MySecret" --query "password" --output tsv
SP_ID=$(az ad sp list --display-name $SP_NAME --query "[0].appId" --output tsv)
SP_TENANT=$(az account show --query "tenantId" --output tsv)

# Set your Azure Container Registry details
az acr update -n pythonregistry3696 --admin-enabled true
ACR_REGISTRY="pythonregistry3696"
ACR_USERNAME=$(az acr credential show --name "pythonregistry3696" --query "username" --output tsv)

# Log in to Azure Container Registry to get Docker credentials
az acr login --name $ACR_REGISTRY
ACR_PASSWORD=$(cat $HOME/.docker/config.json | jq -r '.auths["'$ACR_REGISTRY'"].auth' | base64 --decode | cut -d ':' -f2)

# Set your Azure Kubernetes Service details
AKS_CLUSTER_NAME="myapp"
AKS_RESOURCE_GROUP="rgpythonapp"

# Print the output in the required JSON format
echo -e "{
  \"AZURE_SERVICE_PRINCIPAL_ID\": \"$SP_ID\",
  \"AZURE_SERVICE_PRINCIPAL_SECRET\": \"$SP_SECRET\",
  \"AZURE_TENANT_ID\": \"$SP_TENANT\",
  \"ACR_REGISTRY\": \"$ACR_REGISTRY\",
  \"ACR_USERNAME\": \"$ACR_USERNAME\",
  \"ACR_PASSWORD\": \"$ACR_PASSWORD\",
  \"AKS_CLUSTER_NAME\": \"$AKS_CLUSTER_NAME\",
  \"AKS_RESOURCE_GROUP\": \"$AKS_RESOURCE_GROUP\"
}"
