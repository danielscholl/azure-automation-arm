# Azure Automation with Arm Templates

This repository is a sample solution deploying IaaS supported by OMS Automation and Control.

## Automation And Control Systems

### Prerequisite

Create the required parameter file for deploying the Automation and Control Systems to the desired region.

Parameters (automatecontrol.params.json)

| Parameter               | Default             | Description                                    |
| ----------------------- | ------------------- | ---------------------------------------------- |
| `automationAccountName` | automate            | Azure Automation Account Name                  |
| `automationRegion`      | South Central US    | Azure Region for Automation to be located      |
| `omsWorkspaceRegion`    | East US             | Azure Region for OMS to be located             |
| `_assetLocation`        | * See Note Below    | Source Control Location for Runbooks           |

> Asset Location: https://raw.githubusercontent.com/danielscholl/azure-automation/master/runbooks/ 


### Setup

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Fautomatecontrol.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Fautomatecontrol.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

__Manual Deployment Instructions__

1. Create a Resource Group

```bash
az group create --location southcentralus --name automate-demo
```

2. Deploy Template to Resource Group

```bash
az group deployment create --resource-group automate-demo --template-file templates/automatecontrol.json --parameters templates/automatecontrol.params.json
```


### Automation and Control Solution Details

The Automation and Control Solution deploys and configures the following items.

1. Log Analytics OMS Workspace with Solutions
  - Security Solution
  - Agent Health Assesment
  - Change Tracking
  - Updates
  - Azure Activity

2. Automation Account

3. Automation Account Modules
  - AzureRm.Profile - 3.3.1
  - Azure.Storage - 3.3.1
  - AzureRm.Storage - 3.3.1
  - Azure - 4.3.1
  - AzureRm.Resources - 4.3.1
  - AzureRm.Automation - 3.3.1
  - AzureRm.Compute - 3.3.1
  - AzureRm.Sql - 3.3.1
  - AzureRm.OperationalInsights 3.3.1
  - AzureRm.SiteRecovery - 4.3.1
  - AzureRm.RecoveryServices - 4.3.1
  - AzureRm.Backup - 4.3.1

4. Automation Account Variables
  - omsWorkspaceId
  - omsWorkspaceKey
  - azureSubscriptionId
  - omsRecoveryVault
  - omsResourceGroupName

5. Automation Account Runbooks
  - start-machines
  - stop-machines


## IaaS Solution

### Prerequisite

Parameters (iaas.params.json)

| Parameter               | Default             | Description                                |
| ----------------------- | ------------------- | ------------------------------------------ |
| `servicePrincipalAppId` | _None_              | Service Principal to access KeyVault       |
| `username`              | _None_              | Default Servers Username                   |
| `password`              | _None_              | Default Servers Password                   |

The following cli command can be used to retrieve a service principal.

`az ad user show --upn user@email.com --query objectId -otsv`
