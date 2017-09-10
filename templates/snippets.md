# Template Snippets

### Custom Script Extension

```json
{
  "name": "MyCustomScriptExtension",
  "type": "extensions",
  "apiVersion": "2016-04-30-preview",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[variables('vm1Id')]"
  ],
  "tags": {
    "displayName": "CustomScriptExtension"
  },
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "CustomScriptExtension",
    "typeHandlerVersion": "1.7",
    "autoUpgradeMinorVersion": true,
    "settings": {
      "fileUris": [
        "https://raw.githubusercontent.com/danielscholl/azure-automation-arm/master/scripts/customscript.ps1"
      ],
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File test.ps1"
    }
  }
}
```

### DSC Extension

```json
{
  "name": "Microsoft.Powershell.DSCExtension",
  "type": "extensions",
  "apiVersion": "2016-04-30-preview",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[variables('vm1Id')]"
  ],
  "tags": {
    "displayName": "DSCExtension"
  },
  "properties": {
    "publisher": "Microsoft.Powershell",
    "type": "DSC",
    "typeHandlerVersion": "2.19",
    "autoUpgradeMinorVersion": true,
    "settings": {
      "Properties": {
        "MachineName": "[parameters('vm1Name')]"
      }
    }
  }
}
```

### BGInfo Extension

```json
{
  "name": "Microsoft.Compute.BGInfoExtension",
  "type": "extensions",
  "apiVersion": "2016-04-30-preview",
  "location": "[resourceGroup().location]",
  "dependsOn": [
    "[variables('vm1Id')]"
  ],
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "BGInfo",
    "typeHandlerVersion": "2.1",
    "autoUpgradeMinorVersion": true,
    "settings": {},
    "protectedSettings": null
  }
}
```
