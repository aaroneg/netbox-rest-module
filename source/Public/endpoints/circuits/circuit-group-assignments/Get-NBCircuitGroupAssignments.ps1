<#
.SYNOPSIS
Get the list of circuit group assignments

.DESCRIPTION
Get the list of circuit group assignments

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
Get-NBCircuitGroupAssignments

.NOTES
The number of objects returned may not reflect the full list of objects, if you hit a built-in API limit.
#>
function Get-NBCircuitGroupAssignments {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitGroupAssignmentsAPIPath
}