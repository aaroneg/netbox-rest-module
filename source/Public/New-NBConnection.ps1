function New-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$DeviceAddress,
		[Parameter(Mandatory=$true,Position=1)][string]$ApiKeyID,
		[Parameter(Mandatory=$true,Position=2)][string]$ApiKey,
		[Parameter(Mandatory=$false)][switch]$SkipCertificateCheck,
		[Parameter(Mandatory=$false)][switch]$HttpOnly,
		[Parameter(Mandatory=$false)][switch]$Passthru
	)
	if ($HttpOnly){$ConnScheme='http'} else {$ConnScheme='https'}
	$ConnectionProperties = @{
		Address = "$DeviceAddress"
		ApiKeyID = $ApiKeyID
		ApiKey = $ApiKey
		ApiBaseUrl = "$($ConnScheme)://$($DeviceAddress)/api"
		SkipCertificateCheck = $SkipCertificateCheck
	}
	$Connection = New-Object psobject -Property $ConnectionProperties
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($Connection.Address)' is now the default connection."
	$Script:Connection = $Connection
	if ($Passthru) {
		$Connection
	}
}