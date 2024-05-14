#!/bin/bash

# Check if logged in to Azure CLI
az account show > /dev/null 2>&1
if [ $? != 0 ]; then
    echo "Not logged in to Azure. Please log in and try again."
    az login
fi

# Continue with the script...
resourceGroup="myResourceGroup"
containerGroupName="myContainerGroup"

echo "Removing Azure resources..."
az container delete --name $containerGroupName --resource-group $resourceGroup --yes
echo "Azure resources removed."
