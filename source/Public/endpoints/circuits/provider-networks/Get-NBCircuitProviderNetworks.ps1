<#
.SYNOPSIS
Get Circuit provider network objects

.DESCRIPTION
Get Circuit provider network objects

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBCircuitProviderNetworks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitProviderNetworksAPIPath

}