#Deploying a cluster to a new virtual network (kubenet)
az login
# Connect to Azure Government by setting the cloud with the name AzureUSGovernment.
az cloud set --name AzureUSGovernment
# get the current default subscription using show
az account show --output table
#az account set --subscription "Demonstration Account"


export AZ_RESOURCE_GROUP="AKS-Cloud"
export AZ_CONTAINER_REGISTRY=<YOUR_CONTAINER_REGISTRY>
export AZ_KUBERNETES_CLUSTER="AKSCluster1"
export AZ_LOCATION="usgovvirginia"
export AZ_KUBERNETES_CLUSTER_DNS_PREFIX=<YOUR_UNIQUE_DNS_PREFIX_TO_ACCESS_YOUR_AKS_CLUSTER>

#Create a resource group for the serivces we're going to create
az group create --name $AZ_RESOURCE_GROUP --location $AZ_LOCATION


#Let's create our AKS cluster with default settings
#this will create our virtual network and subnet and will use kubenet.
az aks create \
    --resource-group $AZ_RESOURCE_GROUP \
    --generate-ssh-keys \
    --name $AZ_KUBERNETES_CLUSTER


#Get the kubeconfig to log into the cluster
az aks get-credentials --resource-group $AZ_RESOURCE_GROUP --name $AZ_KUBERNETES_CLUSTER


#Open the Azure Portal, search for AKSCluster1, click on the AKS Service, review the network configuration. 


#Open the Azure Portal, search for AKSCluster1, click on the Managed Cluster Resource Group, click on the VNet
#Examine the VNet address and subnet address


#Nodes are assigned IP addresses from the virtual network that was created by the cluster deployment automatically. 
kubectl get nodes -o wide


#Look at Addresses.InternalIP and PodCIDR, you will see the network range for each node that Pod IPs are allocated from. 
#PodCIDRs will have addressing information for IPV4 and IPV6 if in use.
kubectl describe nodes | more


#Create a workload
kubectl create deployment hello-world \
    --image=gcr.io/google-samples/hello-app:1.0 \
    --replicas=3


#Each Pod is allocated an IP address from the Node's PodCIDR Range.  
kubectl get pods -o wide


#Show parameters for specifying the IP address ranges, Service, PodCIDR, and the network to attach to with vnet-subnet-id
az aks create --help


#We're going to keep this cluster around for some later demos so let's not delete it yet, but if you need to...here you go
#az group delete --name $AZ_RESOURCE_GROUP

