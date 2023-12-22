
# Set Up Your Azure Environment

## Overview
You'll use the Azure CLI to create the Azure resources needed for later units. Before starting, ensure Docker Desktop is installed and running.



## Steps

### 1. Azure CLI Setup
**Note:** To save time, provision the Azure resources first and then proceed to the next unit. Azure Kubernetes Cluster creation can take up to 10 minutes and can optionally run in the background.

#### Authenticate with Azure Resource Manager
Sign in using the Azure CLI:
```bash
az login
```


#### Connect to Azure Government by setting the cloud with the name AzureUSGovernment.
```bash
az cloud set --name AzureUSGovernment
```

#### Select an Azure Subscription
List your Azure subscriptions:
```bash
az account list --output table
```
Set your subscription, replace `<YOUR_SUBSCRIPTION_ID>` with your ID:
```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

### 2. Define Local Variables
Set up the following environment variables. Replace placeholders with your specific values.
```bash
export AZ_RESOURCE_GROUP="rg-diverse-aks"
export AZ_CONTAINER_REGISTRY="acrdiversesample"
export AZ_KUBERNETES_CLUSTER="aksdiverse"
export AZ_LOCATION="usgovvirginia"
export AZ_KUBERNETES_CLUSTER_DNS_PREFIX="diverse-demo-cluster"
export AZ_IMAGE="mynetapp"
```

### 3. Create an Azure Resource Group
Create a Resource group:
```bash
az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION \
    | jq
```
**Note:** This module uses `jq` to format JSON output. You can remove `| jq` if not needed.

### 4. Create an Azure Container Registry
Create a Container registry:
```bash
az acr create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_CONTAINER_REGISTRY \
    --sku Basic \
    | jq
```
Configure Azure CLI for the Azure Container Registry:
```bash
az configure \
    --defaults acr=$AZ_CONTAINER_REGISTRY
```
Authenticate to the Azure Container Registry:
```bash
az acr login -n $AZ_CONTAINER_REGISTRY
```

### 5. Create an Azure Kubernetes Cluster
Create an AKS Cluster:
```bash
az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_KUBERNETES_CLUSTER \
    --attach-acr $AZ_CONTAINER_REGISTRY \
    --dns-name-prefix=$AZ_KUBERNETES_CLUSTER_DNS_PREFIX \
    --generate-ssh-keys \
    | jq
```
**Note:** AKS Cluster creation may take up to 10 minutes. You can proceed to the next unit while this runs.

