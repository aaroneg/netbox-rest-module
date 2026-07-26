<#
.SYNOPSIS
Get all circuit types

.DESCRIPTION
Get all circuit types

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBCircuitTypes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitTypesAPIPath

}