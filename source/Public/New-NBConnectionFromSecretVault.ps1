<#
.SYNOPSIS
Uses credentials stored in SecretVault to create a Netbox connection object.

.DESCRIPTION
This function wraps New-NBConnection, pulling the credential from the SecretStore

.PARAMETER NBHostname
The hostname of your netbox instance.

.PARAMETER MakeDefault
If you leave this value at defaults, this will become the default connection all api commands run against.

.PARAMETER Passthru
Set this flag if you want the details of the connection to be passed back through to the caller (or screen) as a usable connection object - this will include secrets in plain text.

.EXAMPLE
New-NBConnectionFromSecretVault -NBHostname 'netbox-dev.example.com'

.NOTES

#>
function New-NBConnectionFromSecretVault {
	[CmdletBinding()]
	param (
		[Parameter(Position=0)][ValidateNotNull()][string]$NBHostname=$nbconfig.serverAddress,
		[Parameter()][bool]$MakeDefault=$true,
		[Parameter()][switch]$Passthru
	)
	if ($NBHostname.Length -lt 3){throw "Invalid hostname '$NBHostname'"}
	try {
    	$Secret=Get-Secret -Name $NBHostname -AsPlainText -ErrorAction Stop
    	$SecretInfo=Get-SecretInfo -Name $NBHostname | Select-Object -ExpandProperty Metadata
		Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to read secret for $($NBHostname)"
	}
	catch {"Unable to retrieve secret for $($NBHostname)"}
	$ConnectionObject=New-NBConnection -DeviceAddress $NBHostname -ApiKeyID $SecretInfo['KeyID'] -ApiKey $Secret -Passthru -SkipCertificateCheck:$nbconfig.SkipCertificateCheck -HttpOnly:$Nbconfig.httpOnly
	if($MakeDefault){ 
		Write-Verbose "[$($MyInvocation.MyCommand.Name)] Module commands will run against '$($ConnectionObject.Address)' using key with id '$($ConnectionObject.ApiKeyID.Split('_')[1])' by default."
		$Global:Connection = $ConnectionObject
	}
	else{
		Write-Verbose "[$($MyInvocation.MyCommand.Name)] Commands run against '$($ConnectionObject.Address)' will use key with id '$($ConnectionObject.ApiKeyID.Split('_')[1])'"
	}
	if($Passthru){$ConnectionObject}
}