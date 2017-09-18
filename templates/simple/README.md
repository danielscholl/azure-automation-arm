# Simple IaaS infrastructure for testing out DSC and Automation Activities

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FsimpleIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

These 2 templates reduce the complexity of the IaaS solution and deploy a simple VM or a simple VMSS solution to test and debug DSC and Automation Scenarios.



<b>NOTE:</b> The template requires five specific settings:

1. servicePrincipalAppId: This parameter is necessary to add values into the Key Vault. This value can be found by querying command line. `az ad user show --upn user@email.com --query objectId -otsv` 



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
az group create --location southcentralus --name automate-simple
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/simple/deployVMSS.json --parameters templates/simple/deployVMSS.parameters.json --resource-group automate-simple
```
