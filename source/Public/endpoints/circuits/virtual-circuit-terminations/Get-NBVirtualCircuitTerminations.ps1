<#
.SYNOPSIS
Get objects

.DESCRIPTION
Get objects

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBVirtualCircuitTerminations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBVirtualCircuitTerminationsAPIPath
}