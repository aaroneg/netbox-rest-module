<#
.SYNOPSIS
Get all circuit terminations

.DESCRIPTION
Get all circuit terminations

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
Get-NBCircuitTerminations

.NOTES
The number of objects returned may not reflect the full list of objects, if you hit a built-in API limit.
#>
function Get-NBCircuitTerminations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitTerminationsAPIPath
}