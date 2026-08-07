<#
.SYNOPSIS
This is an opinionated function to use the Microsoft.PowerShell.SecretManagement module to store the API key for Netbox for a given hostname. It will optionally configure the secretstore to not use a password so that it can be used in a scheduled task.

.DESCRIPTION
This is an opinionated function to use the Microsoft.PowerShell.SecretManagement module to store the API key for Netbox for a given hostname. It will optionally configure the secretstore to not use a password so that it can be used in a scheduled task. If the modules for the secretstore are missing, it will attempt to install them.

.PARAMETER NBHostname
The hostname for the Netbox configuration instance

.PARAMETER RemovePasswordProtectionOnSecretStore
Pass this flag to ensure that the secretstore can be used non-interactively.

.EXAMPLE
Set-NBCredential -NBHostname netbox-dev.example.com -RemovePasswordProtectionOnSecretStore

.NOTES
In order to remove the password, you will need to already know what it is, and it will affect all credentials in the store, if it already existed. This obviously has security implications, and if you're using it at a business, you should consult your cybersecurity department or company management to get approval for removing this protection layer. This script must run interactively.
#>
function Set-NBCredential {
	[CmdletBinding()]
	param (
		[Parameter(Position=0)][ValidateNotNullOrEmpty()][string]$NBHostname=$nbconfig.serverAddress,
		[Parameter()][switch]$RemovePasswordProtectionOnSecretStore
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Working on hostname $NBHostname"	
	# Environment setup
	if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)) {
		Write-Warning "[$($MyInvocation.MyCommand.Name)] It looks like you're missing the SecretManagement module - will attempt to install the modules required for secretmanagement. You may be prompted to set a password for the secret store or to trust repositories, modules, etc."
		Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore -Scope CurrentUser
	    Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
		Start-Sleep -Seconds 1
		if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)) {
			Write-Warning "[$($MyInvocation.MyCommand.Name)] It looks like we weren't successfull at installing these modules, this command cannot complete successfully"
			throw "Required module missing"
		}
	}
	# Remove the secret vault store, if asked
	if($RemovePasswordProtectionOnSecretStore){
		Write-Warning "[$($MyInvocation.MyCommand.Name)] You will be prompted to confirm that you want to remove the default password authentication for the secret store."	
		Set-SecretStoreConfiguration -Authentication None
	}
	# Get and save the password in the secretvault
    $SecretInput=Read-Host -Prompt 'Netbox v2 API key string (just paste from the web ui)' -MaskInput
    if ($SecretInput -like "Bearer*") {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] v2 API key recognized"
        $Secret=$SecretInput.Split(' ')[1].split('.')[1]
        $SecretKey=$SecretInput.Split(' ')[1].split('.')[0]
		$SecretInfo=Get-SecretInfo -Name $config.serverAddress | Select-Object -ExpandProperty Metadata
    }
	else {
		throw "Key string not recognized as Netbox v2 key - try pasting the string after clicking 'copy' in the Netbox web UI - Should look like 'Bearer nbt_SOMEID.SOMETOKEN'"
	}
    Set-Secret -Name $NBHostname -Secret $Secret -Metadata @{KeyID=$SecretKey}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Secret saved for $NBHostname"	
}