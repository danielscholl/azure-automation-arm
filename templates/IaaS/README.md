# Complex IaaS infrastructure for testing out DSC and Automation Activities

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template configures a complex IaaS deployment and registers it into the OMS Management System



### Prerequisite

Parameters (azuredeploy.params.json)

| Parameter                 | Default             | Description                                |
| ------------------------- | ------------------- | ------------------------------------------ |
| _prefix_                  | my                  | Your unique string (company prefix)        |
| _servicePrincipalAppId_   | _None_              | Service Principal to access KeyVault       |
| _adminUser_               | azureuser           | Default Servers Username                   |
| _adminPassword_           | _None_              | Default Servers Password                   |
| _vnetPrefix_              | 10.1.0.0/24         | Virtual Network Address Space              |
| _frontPrefix_             | 10.1.0.0/25         | Front Subnet Address Space                 |
| _backPrefix_              | 10.1.0.128/26       | Back Subnet Address Space                  |
| _dmzPrefix_               | 10.1.0.192/28       | DMZ Subnet Address Space                   |
| _managePrefix_            | 10.1.0.208/28       | Manage Subnet Address Space                |
| _remoteAccessACL_         | Internet            | IP Segement to allow RDP/SSH Access From   |
| _jumpserverName_          | jumpserver          | VM Name of JumpServer                      |
| _jumpserverSize_          | Standard_A1         | VM Size of JumpServer                      |
| _backendLoadBalanceIP_    | 10.1.0.132          | Static IP Address of Load Balancer         |
| _backendServerNamePrefix_ | vm-back             | Backend Virtual Machine Name               |
| _backendServerSize_       | Standard_A1         | Backend Virtual Machine Size               |
| _backendServerCount_      | 2                   | Number of Backend Servers (2-5)            |
| _scaleSetServerSize_      | Standard_A1         | Virtual Machine ScaleSet Size              |
| _scaleSetInstanceCount_   | 2                   | Number of Instances in VMSS                |
| _omsId_                   | _None_              | OMS Workspace Id                           |
| _omsKey_                  | _None_              | OMS Workspace Key                          |
| _dscRegistrationUrl_      | _None_              | Automation Account DSC URL                 |
| _dscRegistrationKey_      | _None_              | Automation Account Access Key              |
| _scaleSetNodeConfig_      | Frontend.Web        | DSC Node Configuration Name                |


__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-IaaS
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaS/azuredeploy.json --parameters templates/IaaS/params.json --resource-group automate-IaaS
```

