# Debug infrastructure for testing out DSC and Automation Activities

These 2 templates reduce the complexity of the IaaS solution and deploy a simple VM or a simple VMSS solution to test and debug DSC Configurations and Automation Scenarios.


<b>NOTE:</b> The template requires six specific settings:

1. servicePrincipalAppId: This parameter is necessary to add values into the Key Vault. This value can be found by querying command line. `az ad user show --upn user@email.com --query objectId -otsv` 

2. adminPassword:  This parameter, identifies the admin password applied to the machine(s), once it is onboarded. 

3. omsId: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Id can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Workpace ID.

4. omsKey: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Key can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Primary Key.

5. dscRegistrationURL: This parameter enables the DSC Extension and registration of the machine(s) as a DSC Node. This specific URL can be found within the Azure Portal - Automation Account - Account Settings - Keys - URL. 

6. dscRegistrationKey: This parameter enables the DSC Extension and registration of the machine(s) as a DSC Node. This specific URL can be found within the Azure Portal - Automation Account - Account Settings - Keys - Primary Access Key. 

These prerequisites are available only after successful creation and configuration of an Azure Automation and Control Account for Azure.


### Prerequisite

Parameters (params.json)

| Parameter                 | Default                         | Description                                |
| ------------------------- | ------------------------------- | ------------------------------------------ |
| _prefix_                  | dbg                             | Your unique string (company prefix)        |
| _vnetPrefix_              | 10.1.0.0/24                     | Virtual Network Address Space              |
| _subnetPrefix_            | 10.1.0.0/25                     | Subnet Address Space                       |
| _servicePrincipalAppId_   | _None_                          | Service Principal to access KeyVault       |
| _adminUser_               | azureuser                       | Default Servers Username                   |
| _adminPassword_           | _None_                          | Default Servers Password                   |
| _omsId_                   | _None_                          | OMS Workspace Id                           |
| _omsKey_                  | _None_                          | OMS Workspace Key                          |
| _modulesUrl_              | UpdateLCMforAAPull.zip          | OMS Workspace Key                          |
| _dscRegistrationUrl_      | _None_                          | Automation Account DSC URL                 |
| _dscRegistrationKey_      | _None_                          | Automation Account Access Key              |
| _nodeConfigurationName_   | _Backend.Database/Frontend.Web_ | DSC Node Configuration Name                |



__Portal Deployment Instructions__

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FIaaSdebug%2FdeployVM.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

__Manual Deployment Instructions for a VM__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-vm
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaSdebug/deployVM.json --parameters templates/IaaSdebug/params.json --resource-group automate-vm
```

__Manual Deployment Instructions for a VMSS__

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FIaaSdebug%2FdeployVMSS.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-vmss
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaSdebug/deployVMSS.json --parameters templates/IaaSdebug/params.json --resource-group automate-vmss
```
