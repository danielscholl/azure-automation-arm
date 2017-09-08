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
| `adminUser`             | _None_              | Subscription Owner login name                  |
| `adminPassword`         | _None_              | Subscription Owner login password              |

> Asset Location: https://raw.githubusercontent.com/danielscholl/azure-automation/master/runbooks/ 


### Setup

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Ftemplates%2Fautomatecontrol.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-demo
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --resource-group automate-demo --template-file templates/automatecontrol.json --parameters templates/automatecontrol.params.json
```


### Automation and Control Solution Details

The Automation and Control Solution deploys and configures the following items.

1. __Log Analytics OMS Workspace with Solutions__
  - Security Solution
  - Agent Health Assesment
  - Change Tracking
  - Updates
  - Azure Activity

2. __Automation Account__

3. __Automation Account Modules__
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
  - AzureRm.KeyVault = 3.3.1

4. __Automation Account Variables__
  - omsWorkspaceId
  - omsWorkspaceKey
  - azureSubscriptionId
  - omsRecoveryVault
  - omsResourceGroupName

5. __Automation Account Runbooks__
  - start-machines
  - stop-machines


## IaaS Solution

### Prerequisite

Parameters (deployAzure.params.json)

| Parameter                 | Default             | Description                                |
| ------------------------- | ------------------- | ------------------------------------------ |
| `unique`                  | my                  | Your unique string (company prefix)        |
| `servicePrincipalAppId`   | _None_              | Service Principal to access KeyVault       |
| `adminUser`               | azureuser           | Default Servers Username                   |
| `adminPassword`           | _None_              | Default Servers Password                   |
| `vnetPrefix`              | 10.1.0.0/24         | Virtual Network Address Space              |
| `frontPrefix`             | 10.1.0.0/25         | Front Subnet Address Space                 |
| `backPrefix`              | 10.1.0.128/26       | Back Subnet Address Space                  |
| `dmzPrefix`               | 10.1.0.192/28       | DMZ Subnet Address Space                   |
| `managePrefix`            | 10.1.0.208/28       | Manage Subnet Address Space                |
| `remoteAccessACL`         | Internet            | IP Segement to allow RDP/SSH Access From   |
| `jumpserverName`          | jumpserver          | VM Name of JumpServer                      |
| `jumpserverSize`          | Standard_A1         | VM Size of JumpServer                      |
| `backendLoadBalanceIP`    | 10.1.0.132          | Static IP Address of Load Balancer         |
| `backendServerNamePrefix` | vm-back             | Backend Virtual Machine Name               |
| `backendServerSize`       | Standard_A1         | Backend Virtual Machine Size               |
| `backendServerCount`      | 2                   | Number of Backend Servers (2-5)            |
| `scaleSetServerSize`      | Standard_A1         | Virtual Machine ScaleSet Size              |
| `scaleSetInstanceCount`   | 2                   | Number of Instances in VMSS                |

The following cli command can be used to retrieve a service principal.

`az ad user show --upn user@email.com --query objectId -otsv`


### Setup

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Ftemplates%2FdeployAzure.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-demo-iaas
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --resource-group automate-demo-iaas --template-file templates/deployAzure.json --parameters templates/deployAzure.params.json
```

### Infrastructure Solution Details

The IaaS Solsution deploys and configures the following items.

1. __Virtual Network__
  - Subnet: front
  - Subnet: back
  - Subnet: dmz
  - Subnet: manage

2. __Network Security Groups__
  - Subnet Firewall: front-nsg
  - Subnet Firewall: back-nsg
  - Subnet Firewall: dmz-nsg
  - Subnet Firewall: manage-nsg
  - JumpBox Machine Firewall: remote-access-nsg

3. __Storage Account__
  - Diagnostics Storage Account

4. __Key Vault__
  - Contains Default Admin Login Credentials

5. __Load Balancer__
  - Backend Load Balancer
  - Static IP

6. __Virtual Machines__
  - JumpServer on Manage Subnet
    - BGInfo Extension
    - DSC Extension
  - Public IP
  - Multiple Backend Servers
    - BGInfo Extension
    - DSC Extension

7. __App Gateway__
  - Frontend Application Gateway
  - WAF
  - Public IP

8. __Virtual Machine Scale Set__
  - VMSS on Front Network
    - BGInfo Extension
    - DSC Extension



## Architecture

![[0]][0]

[0]: ./media/Architecture.png "Architecture Diagram"
