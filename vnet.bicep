param location string

param prefix string

@description('CIDR of your VNet')
param virtualNetwork_CIDR string = '10.200.0.0/16'

@description('Name of the subnet')
param subnet1Name string = 'Subnet1'

@description('CIDR of your subnet')
param subnet1_CIDR string = '10.200.1.0/24'




resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name:'${prefix}-default-nsg'
  location: location
  properties: {
    securityRules: [   

    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: 'testvnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetwork_CIDR
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: subnet1_CIDR
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}




@description('The resource ID of the virtual network.')
output virtualNetworkId string = virtualNetwork.id
@description('The resource ID of the Subnet.')
output subnet1Id string = virtualNetwork.properties.subnets[0].id
// @description('The resource ID of the Subnet.')
// output acaAppSubnet string = virtualNetwork.properties.subnets[1].id
// @description('The resource ID of the Subnet.')
// output acaControlPlanSubnet string = virtualNetwork.properties.subnets[2].id
// @description('The resource ID of the virtual network.')
// output vnetName string = virtualNetwork.name
// @description('The resource ID of the Subnet.')
// output subnetName string = virtualNetwork.properties.subnets[0].name
