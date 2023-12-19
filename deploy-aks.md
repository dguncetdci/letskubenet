
# Deploy the Container Image to Azure Kubernetes Service

## Overview
This guide will instruct you on deploying a container image to Azure Kubernetes Service (AKS).


## Steps

### 1. Reinitialize Environment (If Necessary)
If your session has idled out or you're starting from another CLI, reinitialize your environment variables and reauthenticate with Azure:
```bash

# Deploy the Container Image to Azure Kubernetes Service

## Overview
This guide will instruct you on deploying a container image to Azure Kubernetes Service (AKS).


## Steps

### 1. Reinitialize Environment (If Necessary)
If your session has idled out or you're starting from another CLI, reinitialize your environment variables and reauthenticate with Azure:
```bash
export AZ_RESOURCE_GROUP="rg-diverse-aks"
export AZ_CONTAINER_REGISTRY="acrdiversesample"
export AZ_KUBERNETES_CLUSTER="aksdiverse"
export AZ_LOCATION="usgovvirginia"
export AZ_KUBERNETES_CLUSTER_DNS_PREFIX="deiverse-demo-cluster"

az login
az acr login -n $AZ_CONTAINER_REGISTRY
```



### 2. Connect to Your Kubernetes Cluster
Install `kubectl` locally and configure it to connect to your AKS cluster.
```bash

az aks get-credentials --resource-group $AZ_RESOURCE_GROUP --name $AZ_KUBERNETES_CLUSTER
```

### 3. Apply Deployment Changes
Apply the changes in your `deployment.yml` file to the AKS cluster.
```bash
kubectl apply -f deployment.yml
```

### 4. Monitor the Deployment Status
Check the status of your deployment.
```bash
kubectl get all
```

If your POD status is Running, the app should be accessible.

### 5. Access the Deployed App
Use the EXTERNAL-IP from your `kubectl get services mynetapp` command to access the running app in AKS.

