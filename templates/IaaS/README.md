# Complex IaaS infrastructure for testing out DSC and Automation Activities

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template configures a complex IaaS deployment and registers it into the OMS Management System



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
az group create --location southcentralus --name automate-IaaS
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaS/azuredeploy.json --parameters templates/IaaS/azuredeploy.parameters.json --resource-group automate-IaaS
```

