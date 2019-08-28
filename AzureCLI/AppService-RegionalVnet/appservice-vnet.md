# Setting up AppService Regional VNet Connectivity via Azure CLI
## Example setup code for RG/VNet/AppService
```
# Variables
subId="3f3bb4b5-6fbf-4967-b37a-53e7c641081b"
rgName="rgAppSvcVNet"
appName="testappsvcvnet"
vnetName="appsvcvnet"
location="WestUS"

# Create a Resource Group
az group create \
  --location $location \
  --name $rgName

# Create a VNet
az network vnet create \
  --name $vnetName \
  --resource-group $rgName \
  --subnet-name webappsubnet

# Create an AppService Plan
az appservice plan create \
  --name $appName \
  --resource-group $rgName \
  --sku S1

# Create a WebApp
az webapp create \
  --name $appName \
  --resource-group $rgName \
  --plan $appName
```

## Delegate the vNet to the AppService provider
```
# Delegate the subnet
az network vnet subnet update \
  --vnet-name $vnetName \
  --name webappsubnet \
  --resource-group $rgName \
  --delegations 'Microsoft.Web/serverFarms'
```

## Use a generic resource update to change the config/virtualNetwork properties
```
# Attach the WebApp to the delegated subnet
az resource update \
  --ids "/subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Web/sites/$appName/config/virtualNetwork" \
  --set properties.swiftSupported=true \
  --set properties.subnetResourceId=/subscriptions/$subId/resourceGroups/$rgName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/webappsubnet
```