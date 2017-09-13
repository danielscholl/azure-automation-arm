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
Param (
  [Parameter(Mandatory=$true)]
  [String] $SubscriptionName,

  [Parameter(Mandatory=$true)]
  [String] $ResourceGroup,
 
  [Parameter(Mandatory=$true)]
  [String] $AutomationName="automate",
 
  [Parameter(Mandatory=$true)]
  [SecureString] $CertPassword
  )

  
#########################
# LOGIN TO AZURE AND START
#########################
#Login-AzureRmAccount

Write-Host -foregroundcolor "yellow"  "Selecting Subscription: $SubscriptionName ..."

$SubscriptionInfo = Get-AzureRmSubscription -SubscriptionName $SubscriptionName 
Select-AzureRmSubscription -SubscriptionId $SubscriptionInfo.SubscriptionId



#########################
# RUN AS ACCOUNT
#########################
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CertPassword)
$CertPlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$CurrentDate = Get-Date
$EndDate = $CurrentDate.AddMonths(12)
$KeyId = (New-Guid).Guid


$CertDir = (Get-Location).Path + "\.certs"
if (!(Test-Path -Path $CertDir )) {
  New-Item -ItemType directory -Path $CertDir
}
$CertPath = Join-Path $CertDir ($AutomationName + ".pfx")


### Create Self Signed Certificate
Write-Host -foregroundcolor "yellow" "Creating Certificate $CertPath"

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

Write-Output $KeyCredential


### Create Service Principals and assign Role
Write-Host -foregroundcolor "yellow" "Creating Azure AD Application: $AutomationName ..."

$Application = New-AzureRmADApplication -DisplayName $AutomationName `
  -HomePage ("http://" + $AutomationName) `
  -IdentifierUris ("http://" + $KeyId) `
  -KeyCredentials $keyCredential

Write-Output $Application

New-AzureRMADServicePrincipal -ApplicationId $Application.ApplicationId | Write-Verbose
Get-AzureRmADServicePrincipal | Where {$_.ApplicationId -eq $Application.ApplicationId} | Write-Verbose


$NewRole = $null
$Retries = 0;
While ($NewRole -eq $null -and $Retries -le 2) {
  Write-Host -foregroundcolor "yellow"  "Attempting Assignment of Contributor Role to Application..."
  # Sleep here for a few seconds to allow the service principal application to become active (should only take a couple of seconds normally)
  Sleep 5
  New-AzureRMRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $Application.ApplicationId | Write-Verbose
  Sleep 5
  $NewRole = Get-AzureRMRoleAssignment -ServicePrincipalName $Application.ApplicationId -ErrorAction SilentlyContinue
  $Retries++;
}


### Create the Automation Certificate
Write-Host -foregroundcolor "yellow"  "Creating Automation Certificate: AzureRunAsCertificate..."
New-AzureRmAutomationCertificate -Name AzureRunAsCertificate `
  -ResourceGroupName $ResourceGroup `
  -AutomationAccountName $AutomationName `
  -Path $CertPath `
  -Password $CertPassword `
  -Exportable | write-verbose


### Create the Automation Connection
Write-Host -foregroundcolor "yellow"  "Creating Automation Connection: AzureRunAsCertificate..."
$ConnectionFieldValues = @{
  "ApplicationId"         = $Application.ApplicationId;
  "TenantId"              = $SubscriptionInfo.TenantId;
  "CertificateThumbprint" = $Cert.Thumbprint;
  "SubscriptionId"        = $SubscriptionInfo.SubscriptionId
}

New-AzureRmAutomationConnection -Name AzureRunAsCertificate `
  -ResourceGroupName $ResourceGroup `
  -AutomationAccountName $AutomationName `
  -ConnectionTypeName AzureServicePrincipal `
  -ConnectionFieldValues $ConnectionFieldValues

  Write-Host -foregroundcolor "yellow"  "COMPLETED!"