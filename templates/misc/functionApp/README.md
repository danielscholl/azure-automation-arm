# VM-DSC-Extension-Azure-Automation-Pull-Server

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fdanielscholl%2Fmaster%2Fazure-automation-arm%2Ftemplates%2FfunctionApp%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>


This template configures a function App and deploys a function to support ARM Template GUID creation processes.

<b>NOTE:</b> The functionApp module requires one specific settings:

1. prefix: This parameter sets the unique prefix often used as a company 2 or 3 letter code.



__Manual Deployment Instructions__

1. __Deploy Template to Resource Group__

```bash
az group deployment create --template-file templates/functionApp/azuredeploy.json --parameters templates/functionApp/azuredeploy.parameters.json --resource-group automate-demo
```


