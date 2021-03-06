# Azure Automation with Arm Templates

This repository is a sample solution deploying IaaS supported by OMS Automation and Control.

## Automation And Control Systems

### Prerequisite

<b>The arm template requires 6 specific settings:</b>

Copy the sample paramteters file required for deploying the Automation and Control system and edit it with the desired values.

```bash
cp templates/azuredeploy.parameters.json templates/params.json
```

Parameters (params.json)

| Parameter               | Default             | Description                                    |
| ----------------------- | ------------------- | ---------------------------------------------- |
| _prefix_                | my                  | Your unique string (company prefix)            |
| _omsWorkspaceRegion_    | East US             | Azure Region for OMS to be located             |
| _automationAccountName_ | automate            | Azure Automation Account Name                  |
| _automationRegion_      | South Central US    | Azure Region for Automation to be located      |
| _assetLocation_         | *See Note 1 Below  | Source Control Location for Runbooks           |
| _repoURL_               | *See Note 2 Below  | Source Control Location for Runbooks           |
| _adminUser_             | _None_              | Subscription Owner login name                  |
| _adminPassword_         | _None_              | Subscription Owner login password              |

<b>NOTE 1:</b> Runbooks are automatically uploaded from the directory runbooks.  The default location of this can be changed if desired. 

Runbooks Location:  https://github.com/danielscholl/azure-automation-arm/runbooks
 
Automatic ARM template creation of the "RunAs" Account isn't possible.  2 Solutions exist to solve this problem with Option 1 implemented.

 __Option 1__: The template automatically creates a schedule to run the runbook "bootstrap."  This uses Azure to run powershell
 commands and creates a temporary Key Vault to generate a certificate that then is used for the RunAs account.  In order
 to execute activities in the Azure Subscription a user/password with contributor rights to the subscription are temporarily stored as credentials in the automation account and deleted upon succesful completion of the runbook.  It is important to know however that if the credentials have 2 Factor Authentication requirements the Runbook job will fail.

 __Option 2__: In order to manually create the Run As Account the script create-runas-account.ps1 can be run which will create the certificates on the local machine and then upload the certificates to the automation account.

<b>NOTE 2:</b> This ARM template uses an Azure Function to create unique GUIDs neecessary for job automation.

Repo URL:  https://github.com/danielscholl/azure-functions

In order to prevent having to submit a growing number of GUIDs via parameters, an Azure Function is utilized to
creates a dynamic template with (x) number of GUIDs from a URL.

URL Example: https://<your_function_app>.azurewebsites.net/api/guidTemplate?count=2
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "guid0": {
      "type": "string",
      "value": "33f8f633-03ed-4d7d-9111-69ea3bbcb655"
    },
    "guid1": {
      "type": "string",
      "value": "e3473867-e90f-4706-ae74-390384013641"
    }
  }
}
```

### Setup

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Ftemplates%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/azuredeploy.json --parameters templates/params.json --resource-group automate
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

6. __Automation Account DSC__
  - Backend.Database
  - Frontend.Web


## IaaS Solution

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

The following cli command can be used to retrieve a service principal.

`az ad user show --upn user@email.com --query objectId -otsv`

To get the OMS Workspace Id and Key the portal must be used.

1. Go to the Microsoft Operations Management Suite
  - Connected Sources
  - Windows Servers

### Setup

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdanielscholl%2Fazure-automation-arm%2Fmaster%2Ftemplates%2FIaaS%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

__Manual Deployment Instructions__

1. __Create a Resource Group__

```bash
az group create --location southcentralus --name automate-iaas
```

2. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/IaaS/azuredeploy.json --parameters templates/IaaS/params.json --resource-group automate-iaas
```

### Infrastructure Solution Details

The IaaS Solution deploys and configures the following items.

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
    - Diagnostics Extension
    - OMS Agent Configuration Extension
    - DSC Extensionn
  - Public IP
  - Multiple Backend Servers
    - BGInfo Extension
    - Diagnostics Extension
    - OMS Agent Configuration Extension
    - DSC Extension
  - 2 Managed Data Disks

7. __App Gateway__
  - Frontend Application Gateway
  - Public IP

8. __Virtual Machine Scale Set__
  - VMSS on Front Network
    - BGInfo Extension
    - Diagnostics Extension
    - OMS Agent Configuration Extension
    - DSC Extension
    

## Architecture

![[0]][0]

[0]: ./media/Architecture.png "Architecture Diagram"
