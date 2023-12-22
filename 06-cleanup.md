## Step-07: Clean-Up

### Get all Objects in default namespace
```bash
kubectl get all
```

### Delete Services
```bash
kubectl delete svc mynetsample
```

### Delete Deployment
```bash
kubectl delete deployment mynetsample-deployment
```

### Delete Pod
```bash
kubectl delete pod my-first-pod
```

### Get all Objects in default namespace
```bash
kubectl get all
```


### Steps
Delete the resource groups as a way to delete all contained Azure resources.

⚠️ Ensure you are using the correct subscription, and validate that the only resources that exist in these groups are ones you're okay deleting.
```bash
az group delete -n $AZ_RESOURCE_GROUP
```
