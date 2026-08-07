function Remove-NBCredential {
	[CmdletBinding()]
	param (
		[Parameter(Position=0)][ValidateNotNullOrEmpty()][string]$NBHostname=$nbconfig.serverAddress,
		[Parameter(Position=1)][string]$VaultName='SecretStore'
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to remove secret for $($NBHostname)"
	try {Remove-Secret -Name $NBHostname -Vault $VaultName -ErrorAction Stop}
	catch {throw "Unable to remove secret - maybe it does not exist?"}
}