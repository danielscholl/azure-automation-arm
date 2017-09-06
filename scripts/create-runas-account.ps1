<# Copyright (c) 2017, cloudcodeit.com
.Synopsis
   Installs a Virtual Machine to an isolated Resource Group with an automation account
.DESCRIPTION
   This script will install a virtual machine, Storage, Network
   into its own resource group. It will setup an Azure Automation account.
.EXAMPLE
   ./initialize.ps1 -Prefix <your_unique_string> -ResourceGroup <your_group> <your_vmname> <your_location>
#>

#Requires -RunAsAdministrator

param([string]$ResourceGroupName = "rg-automate",
  [string]$AutomationName = "automate")

#########################
# LOGIN TO AZURE AND START
#########################
Login-AzureRmAccount

$SubscriptionInfo = Get-AzureRmSubscription
$TenantID = $SubscriptionInfo | Select TenantId -First 1
$SubscriptionID = $SubscriptionInfo | Select SubscriptionId -First 1


#########################
# RUN AS ACCOUNT
#########################
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
$CertPlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$CurrentDate = Get-Date
$EndDate = $CurrentDate.AddMonths(12)
$KeyId = (New-Guid).Guid
$AssetConnection = "AzureRunAsConnection"

$CertDir = (Get-Location).Path + "\.certs"
if (!(Test-Path -Path $CertDir )) {
  New-Item -ItemType directory -Path $CertDir
}
$CertPath = Join-Path $CertDir ($AutomationName + ".pfx")

# Create Self Signed Certificate
$Cert = New-SelfSignedCertificate -DnsName $AutomationName `
  -CertStoreLocation cert:\LocalMachine\My `
  -KeyExportPolicy Exportable `
  -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider"

$CertPassword = ConvertTo-SecureString $CertPlainPassword -AsPlainText -Force
Export-PfxCertificate -Cert ("Cert:\localmachine\my\" + $Cert.Thumbprint) -FilePath $CertPath -Password $CertPassword -Force | Write-Verbose

$PFXCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate -ArgumentList @($CertPath, $CertPlainPassword)
$KeyValue = [System.Convert]::ToBase64String($PFXCert.GetRawCertData())
$KeyCredential = New-Object  Microsoft.Azure.Commands.Resources.Models.ActiveDirectory.PSADKeyCredential
$KeyCredential.StartDate = $CurrentDate
$KeyCredential.EndDate = $EndDate
$KeyCredential.KeyId = $KeyId
$KeyCredential.CertValue = $KeyValue

# Create Service Principals and assign Role
$Application = New-AzureRmADApplication -DisplayName $AutomationName `
  -HomePage ("http://" + $AutomationName) `
  -IdentifierUris ("http://" + $KeyId) `
  -KeyCredentials $keyCredential

New-AzureRMADServicePrincipal -ApplicationId $Application.ApplicationId | Write-Verbose
Get-AzureRmADServicePrincipal | Where {$_.ApplicationId -eq $Application.ApplicationId} | Write-Verbose

$NewRole = $null
$Retries = 0;
While ($NewRole -eq $null -and $Retries -le 2) {
  # Sleep here for a few seconds to allow the service principal application to become active (should only take a couple of seconds normally)
  Sleep 5
  New-AzureRMRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $Application.ApplicationId | Write-Verbose
  Sleep 5
  $NewRole = Get-AzureRMRoleAssignment -ServicePrincipalName $Application.ApplicationId -ErrorAction SilentlyContinue
  $Retries++;
}

# Create the Automation Certificate
New-AzureRmAutomationCertificate -Name AzureRunAsCertificate `
  -ResourceGroupName $ResourceGroupName `
  -AutomationAccountName $AutomationName `
  -Path $CertPath `
  -Password $CertPassword `
  -Exportable | write-verbose


$ConnectionFieldValues = @{
  "ApplicationId"         = $Application.ApplicationId;
  "TenantId"              = $TenantID.TenantId;
  "CertificateThumbprint" = $Cert.Thumbprint;
  "SubscriptionId"        = $SubscriptionID.SubscriptionId
}

New-AzureRmAutomationConnection -Name $AssetConnection `
  -ResourceGroupName $ResourceGroupName `
  -AutomationAccountName $AutomationName `
  -ConnectionTypeName AzureServicePrincipal `
  -ConnectionFieldValues $ConnectionFieldValues
