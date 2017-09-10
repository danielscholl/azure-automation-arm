# Simple IaaS infrastructure for testing out DSC and Automation Activities

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FsimpleIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template configures a Virtual Machine and registers it into the OMS Management System


<b>NOTE:</b> The template requires five specific settings:

1. servicePrincipalAppId: This parameter is necessary to add values into the Key Vault. This value can be found by querying command line. `az ad user show --upn user@email.com --query objectId -otsv` 

2. omsId: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Id can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Workpace ID.

2. omsKey: This parameter, enables the onboarding of the VM OMS Agent to Azure Automation and Control. This specific Key can be found within the Azure Portal - OMS Portal - Settings - Connected Sources - Windows Servers - Primary Key.

4. username: This parameter, identifies the VM admin name applied to the VM, once it is onboarded. 

5. password: This parameter, identifies the VM admin password applied to the VM, once it is onboarded. 

These prerequisites are available only after successful creation and configuration of an Azure Automation and Control Account for Azure.


### Prerequisite

Parameters (deployAzure.params.json)

| Parameter                 | Default             | Description                                |
| ------------------------- | ------------------- | ------------------------------------------ |
| _servicePrincipalAppId_   | _None_              | Service Principal to access KeyVault       |
| _omsId_                   | _None_              | OMS Workspace Id                           |
| _omsKey_                  | _None_              | OMS Workspace Key                          |
| _adminUser_               | azureuser           | Default Servers Username                   |
| _adminPassword_           | _None_              | Default Servers Password                   |


__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-simpleIaaS
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/simpleIaaS/deployAzure.json --parameters templates/simpleIaaS/deployAzure.params.json --resource-group automate-simpleIaaS
```
