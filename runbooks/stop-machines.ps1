<#
    .DESCRIPTION
        This runbook stops all of the virtual machines in the specified Azure Resource Group.

    .PARAMETER ResourceGroupName
        Name of the Azure Resource Group containing the VMs to be stopped.

    .NOTES
        AUTHOR: Daniel Scholl
#>
workflow stop-machines {
  Param(
  		[string]$ResourceGroupName
  )

  inlineScript {
    $ResourceGroupName = $using:ResourceGroupName

    $connectionName = "AzureRunAsConnection"
    try {
      # Get the connetion  "AzureRunAsConnection"
      $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName

      "Logging in to Azure..."
      Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint
    }
    catch {
      if (!$servicePrincipalConnection) {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
      }
      else {
        Write-Error -Message $_.Exception
        throw $_.Exception
      }
    }

    $Machines = Get-AzureRmVM -ResourceGroupName $ResourceGroupName

    if (!$Machines) {
      Write-Output "No VMs found in the Resource Group."
    }
    else {
      $Machines | ForEach-Object {
        Write-Output "Stopping Server $_.Name"
        Stop-AzureRMVM -Name $_.Name `
          -ResourceGroupName $ResourceGroupName `
          -Force
      }
    }
  }
}
