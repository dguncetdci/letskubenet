# Flux v2 on AKS 

You need the following to run the commands:

- An Azure subscription with a deployed AKS cluster; a single node will do
- Azure CLI and logged in to the subscription with owner access
- All commands run in bash, in my case in WSL 2.0 on Windows 11
- kubectl and a working kube config (use az aks get-credentials)

## Register AKS Extension Manager

```bash
# register the feature

# ensure you run Azure CLI 2.15 or later
# the command will show the version; mine showed 2.36.0
az version | grep '"azure-cli"'
 
# register the following providers; if these providers are already
# registered, it is safe to run the commands again
 
az provider register --namespace Microsoft.Kubernetes
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.KubernetesConfiguration
 
# enable CLI extensions or upgrade if there is a newer version
az extension add -n k8s-configuration --upgrade
az extension add -n k8s-extension --upgrade
 
# check your Azure CLI extensions
az extension list -o table
```

## Create Resource Group and Aks Cluster with Gateway
###Deploy a cluster with an AppGW Ingress Controller for application access
```bash
export AZ_RESOURCE_GROUP="AKS-Cloud-AppGateway"
export AZ_KUBERNETES_CLUSTER="AKSClusterAppGateway"
export AZ_LOCATION="usgovvirginia"

az group create --name $AZ_RESOURCE_GROUP --location $AZ_LOCATION

```
## Create a cluster with the AppGW Ingress addon

```bash
az aks create \
    --resource-group $AZ_RESOURCE_GROUP  \
    --name $AZ_KUBERNETES_CLUSTER \
    --network-plugin azure \
    --enable-managed-identity \
    --enable-addon ingress-appgw \
    --appgw-name aks-appgw \
    --appgw-subnet-cidr "10.225.0.0/16" \
    --generate-ssh-keys
```
## Install Flux v2

```bash

# list installed extensions
az k8s-extension list -g $AZ_RESOURCE_GROUP -c $AZ_KUBERNETES_CLUSTER -t managedClusters
 
# install flux; note that the name (-n) is a name you choose for
# the extension instance; the command will take some time
# this extension will be installed with cluster-wide scope
```


## Install flux 

```bash 
az k8s-extension create -g $AZ_RESOURCE_GROUP -c $AZ_KUBERNETES_CLUSTER -n flux --extension-type microsoft.flux -t managedClusters --auto-upgrade-minor-version true
```
# list Kubernetes namespaces; there should be a flux-system namespace
```bash
kubectl get ns
 
# get pods in the flux-system namespace
kubectl get pods -n flux-system
```

## Install net sample application using flux and gitops
```bash
az k8s-configuration flux create -g $AZ_RESOURCE_GROUP -c $AZ_KUBERNETES_CLUSTER -t managedClusters --name example -u https://github.com/dguncetdci/letskubenet.git --branch main -k name=app path=./manifests
```

