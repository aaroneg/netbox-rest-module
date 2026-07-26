<#
.SYNOPSIS
Get a circuit provider network object by name

.DESCRIPTION
Get a circuit provider network object by name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
The Name of the object to retrieve
#>
function Get-NBCircuitProviderNetworkByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBCircuitProviderNetworksAPIPath -value $name

}