targetScope = 'subscription'

// General Parameters Version1
// =================
@description('The location to deploy resources to.')
param location string = 'uksouth'
@description('The Resource Group to deploy resources to.')
param vnetResourceGroupName string = 'vnetRG' //change
@description('The Resource Group to deploy resources to.')
param webappResourceGroupName string = 'webappRG' //change
@description('The Name for Resources.')
param prefix string = 'labda-dev'

// Create Resource Group For Vnet
// =================================
resource vnetRG 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: vnetResourceGroupName
  location: location
}

// Create Resource Group For Infrastructure
// =================================
resource Webapp 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: webappResourceGroupName
  location: location
}

// Create Virtual Network, Subnet, NSG
module Network './vnet.bicep' = {
  name: '${uniqueString(deployment().name, location)}-network-deployment'
  scope: resourceGroup(vnetRG.name)
  params: {
    location:location
    prefix: prefix
  }
}

module WebApp './fe.bicep' = {
 name: '${uniqueString(deployment().name, location)}-webapp'
 scope: resourceGroup(Webapp.name)
 params: {
    subnetId: Network.outputs.subnet1Id
    //  vnetName: Network.outputs.vnetName
     location: location
  }
}
