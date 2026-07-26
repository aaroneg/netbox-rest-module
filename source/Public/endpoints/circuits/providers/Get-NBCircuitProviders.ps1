<#
.SYNOPSIS
Get all circuit ID providers

.DESCRIPTION
Get all circuit ID providers

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBCircuitProviders {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitProvidersAPIPath

}