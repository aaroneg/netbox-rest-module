function New-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$DeviceAddress,
		[Parameter(Mandatory=$true,Position=1)][string]$ApiKey,
		[Parameter(Mandatory=$false)][string]$SkipCertificateCheck,
		[Parameter(Mandatory=$false)][switch]$Passthru
	)
	$ConnectionProperties = @{
		Address = "$DeviceAddress"
		ApiKey = $ApiKey
		ApiBaseUrl = "https://$($DeviceAddress)/api"
	}
	$Connection = New-Object psobject -Property $ConnectionProperties
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($Connection.Address)' is now the default connection."
	$Script:Connection = $Connection
	if ($Passthru) {
		$Connection
	}
}
function Test-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)][object]$NBConnection
	)
	if (!($NBConnection)) { 
		Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying Default Connection"
		$NBConnection=$Script:Connection
	}

	"Connection OK`nNetbox Version: "+(Get-NBStatus -Connection $NBConnection)."netbox-version"
}

function Get-NBCurrentConnection {
	"Default Netbox Connection:"
	$Script:Connection
}

Export-ModuleMember -Function "*-*"
