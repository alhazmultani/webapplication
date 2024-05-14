#!/bin/bash
az account show > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "Not logged in to Azure. Please log in and try again."
    az login
fi
# Set variables
resourceGroup="FoodiWeb_group"  # change to your Azure resource group name
location="eastus"                # change to your desired Azure region
containerName="FoodiWeb"
imageName="foodie/foodapp:latest"  # change to your image name on Docker Hub
dnsNameLabel="foodapp-container-${RANDOM}"        # unique DNS name for the container

# Login to Azure (uncomment the next line if running locally and not logged in)
# az login

# Create a resource group if it does not exist
echo "Creating resource group..."
az group create --name $resourceGroup --location $location

# Create the container instance
echo "Deploying container to Azure Container Instances..."
az container create \
    --resource-group $resourceGroup \
    --name $containerName \
    --image $imageName \
    --dns-name-label $dnsNameLabel \
    --ports 80 443 \
    --environment-variables \
        ASPNETCORE_ENVIRONMENT=Production \
    --os-type Linux

# Display the FQDN
fqdn=$(az container show --resource-group $resourceGroup --name $containerName --query ipAddress.fqdn --output tsv)
echo "Application is running at: http://$fqdn"
