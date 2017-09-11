# VM-DSC-Extension-Azure-Automation-Pull-Server

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2Fdscpullserver%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


This template configures an existing Virtual Machine Local Configuration Manager (LCM) via the DSC extension, registering it to an existing Azure Automation Account DSC Pull Server.

<b>NOTE:</b> The DSC configuration module requires four specific settings:

1. modulesUrl: This parameter sets the URL for the zipped PS1 file responsible for passing the ARM Template values through the DSC VM Extension to configure the LCM, onboarding the VM to Azure Automation DSC. Both the Default value for this parameter and the azuredeploy.parameters.json for this template has the appropriate value for this parameter, as it references the RAW content URL for the provided module here in GitHub.

2. registrationKey: This parameter, combined with registrationUrl, enables the onboarding of the VM to Azure Automation DSC. This account specific Key can be found within the Azure Portal - Automation Account - Account Settings - Keys - Primary Access Key.

3. registrationUrl: This parameter, combined with registrationKey, enables the onboarding of the VM to Azure Automation DSC. This account specific URL can be found within the Azure Portal - Automation Account - Account Settings - Keys - URL.

4. nodeConfigurationName: This parameter, identifies the name of the Azure Automation DSC Configuration to be applied to the VM, once it is onboarded. These Azure Automation DSC Configurations can be created and referenced within the Azure Portal - Automation Account - DSC Configurations.

   i. As an example, nodeConfigurationName would be set to MyWebConfig.WebServer in the following PowerShell DSC Module snippet:

      Configuration MyWebConfig {
           Node "WebServer" {
		   ...
           }

These prerequisites are available only after successful creation and configuration of an Azure Automation Account for Azure Automation DSC and a Virtual Machine.

__Manual Deployment Instructions__

1. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/dscpullserver/deployAzure.json --parameters templates/dscpullserver/deployAzure.params.json --resource-group automate-simpleIaaS
```


