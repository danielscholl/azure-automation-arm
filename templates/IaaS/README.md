# Complex IaaS infrastructure for testing out DSC and Automation Activities


This template installs a complex IaaS solution using the Automation and Control Solution.


<b>NOTE:</b> The template requires six specific settings:

1. servicePrincipalAppId: This parameter is necessary to add values into the Key Vault. This value can be found by querying command line. `az ad user show --upn user@email.com --query objectId -otsv` 

2. adminPassword:  This parameter, identifies the admin password applied to the machine(s), once it is onboarded. 

3. omsId: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Id can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Workpace ID.

4. omsKey: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Key can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Primary Key.

5. dscRegistrationURL: This parameter enables the DSC Extension and registration of the machine(s) as a DSC Node. This specific URL can be found within the Azure Portal - Automation Account - Account Settings - Keys - URL. 

6. dscRegistrationKey: This parameter enables the DSC Extension and registration of the machine(s) as a DSC Node. This specific URL can be found within the Azure Portal - Automation Account - Account Settings - Keys - Primary Access Key. 

These prerequisites are available only after successful creation and configuration of an Azure Automation and Control Account for Azure.


### Prerequisite

Copy the sample parameters file required for deploying the IaaS Solution and edit it with the desired values.

```bash
cp templates/IaaS/azuredeploy.parameters.json templates/IaaS/params.json
```

Parameters (params.json)

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
| _vmNodeConfig_            | Backend.Database    | DSC Node Configuration Name                |



__Portal Deploment Instructions__

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-IaaS
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaS/azuredeploy.json --parameters templates/IaaS/params.json --resource-group automate-IaaS
```

