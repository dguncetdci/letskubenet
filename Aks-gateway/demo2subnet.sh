#Deploying a cluster to a new virtual network (kubenet)
az login
# Connect to Azure Government by setting the cloud with the name AzureUSGovernment.
az cloud set --name AzureUSGovernment
# get the current default subscription using show
az account show --output table
#az account set --subscription "Demonstration Account"


export AZ_RESOURCE_GROUP="AKS-Cloud-ExistingNetwork"
export AZ_CONTAINER_REGISTRY=<YOUR_CONTAINER_REGISTRY>
export AZ_KUBERNETES_CLUSTER="AKSCluster1"
export AZ_LOCATION="usgovvirginia"
export AZ_KUBERNETES_CLUSTER_DNS_PREFIX=<YOUR_UNIQUE_DNS_PREFIX_TO_ACCESS_YOUR_AKS_CLUSTER>

#Azure CNI Cluster Creation into existing networking
az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION


#AKS clusters may not use 169.254.0.0/16, 172.30.0.0/16, 172.31.0.0/16, or 192.0.2.0/24 
#for the Kubernetes service address range, pod address rangem cluster virtual network address and subnet range.
#Also, don't want any of these to overlap with on-premises IPs or other VNETs
az network vnet create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name network-existing \
  --address-prefix 10.0.0.0/12 \
  --subnet-name subnet-existing \
  --subnet-prefix 10.1.0.0/16 


SUBNET_ID=$(az network vnet subnet show --resource-group $AZ_RESOURCE_GROUP --vnet-name network-existing --name subnet-existing --query id -o tsv)
echo $SUBNET_ID


#Deploy our cluster into that existing network using Azure CNI
#You can use a service principal, managed identity or a system assigned identity
#The network resources will be in the resource group "AKS-Cloud-ExistingNetwork" 
#The AKS managed resources will still be in the MC resource group. This includes dynamically created resources like Load Balancers

az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name ExistingNetwork \
    --network-plugin azure \
    --vnet-subnet-id "/subscriptions/7c2582e5-2189-47b1-931c-21ca2f1e55c4/resourceGroups/AKS-Cloud-ExistingNetwork/providers/Microsoft.Network/virtualNetworks/network-existing/subnets/subnet-existing" \
    --enable-managed-identity 

#/subscriptions/7c2582e5-2189-47b1-931c-21ca2f1e55c4/resourceGroups/AKS-Cloud-ExistingNetwork/providers/Microsoft.Network/virtualNetworks/network-existing/subnets/subnet-existing"
#Get the kubeconfig to log into the cluster
az aks get-credentials --resource-group $AZ_RESOURCE_GROUP --name ExistingNetwork


#Create a workload
kubectl create deployment hello-world \
    --image=gcr.io/google-samples/hello-app:1.0 \
    --replicas=3


#The pods get addresses on the real Azure Virtual Network Subnet that we created above with the address range of 10.1.0.0/16 
kubectl get pods -o wide


#Deploy a service with a load balancer to ensure networking is properly configured
kubectl expose deployment hello-world \
     --port=80 \
     --target-port=8080 \
     --type LoadBalancer


#Test Application with curl
kubectl get service
LOADBALANCERIP=$(kubectl get service hello-world -o jsonpath='{ .status.loadBalancer.ingress[].ip }')
curl http://$LOADBALANCERIP


#Clean up from this demo
#az group delete --name $AZ_RESOURCE_GROUP




#################################
#Service Principal Example Code##
#################################
az network vnet create \
  --resource-group $AZ_RESOURCE_GROUP \
  --name network-existing \
  --address-prefix 10.0.0.0/12 \
  --subnet-name subnet-existing \
  --subnet-prefix 10.1.0.0/16 


az ad sp create-for-rbac
VNET_ID=$(az network vnet show --resource-group $AZ_RESOURCE_GROUP --name network-existing --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show --resource-group $AZ_RESOURCE_GROUP --vnet-name network-existing --name subnet-existing --query id -o tsv)

echo $VNET_ID
echo $SUBNET_ID

export appId=$(az ad signed-in-user show --query id --output tsv)
echo $appId
az role assignment create --assignee $appId --scope $VNET_ID --role "Network Contributor"


#Deploy our cluster into that existing network using Azure CNI
#You can use a service principal, managed identity or a system assigned identity
export appId=$(az ad signed-in-user show --query objectId --output tsv)
echo $appId

az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name ExistingNetwork \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET_ID \
    --service-principal $appId \
    --client-secret "mysecret"