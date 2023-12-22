
# Push the Container Image to Azure Container Registry

## Overview
pushing a container image to Azure Container Registry (ACR).


## Steps

### 1. Reinitialize Environment (If Necessary)

If your session has idled out, reinitialize your environment variables and reauthenticate with Azure:
```bash
export AZ_RESOURCE_GROUP="rg-diverse-aks"
export AZ_CONTAINER_REGISTRY="acrdiversesample"
export AZ_KUBERNETES_CLUSTER="aksdiverse"
export AZ_LOCATION="usgovvirginia"
export AZ_KUBERNETES_CLUSTER_DNS_PREFIX="deiverse-demo-cluster"
export AZ_IMAGE="mynetapp"

az login
az acr login -n $AZ_CONTAINER_REGISTRY
```

### 2. Push the Container Image
#### Sign in to Azure Container Registry
```bash
TOKEN=$(az acr login --name $AZ_CONTAINER_REGISTRY --expose-token --output tsv --query accessToken)
docker login $AZ_CONTAINER_REGISTRY.azurecr.us --username 00000000-0000-0000-0000-000000000000 --password-stdin <<< $TOKEN
```

#### Tag the Built Container Image
```bash
docker tag mynetapp $AZ_CONTAINER_REGISTRY.azurecr.us/mynetapp
```

#### Push the Image to Azure Container Registry
```bash
docker push $AZ_CONTAINER_REGISTRY.azurecr.us/mynetapp
```

### 3. Verify the Pushed Image
Run the following command to view the image metadata in Azure Container Registry:
```bash
az acr repository show -n $AZ_CONTAINER_REGISTRY --image mynetapp:latest
```

You will see output showing the image attributes including its digest and creation time.

---

Your container image is now in the Azure Container Registry, ready for deployment by Azure services such as Azure Kubernetes Service.
