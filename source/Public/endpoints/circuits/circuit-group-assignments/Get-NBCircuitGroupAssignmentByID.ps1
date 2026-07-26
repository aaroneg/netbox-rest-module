<#
.SYNOPSIS
Get a circuit group assignment by the ID of the assignment

.DESCRIPTION
Get a circuit group assignment by the ID of the assignment

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of an existing circuit group assignment

.EXAMPLE
Get-NBCircuitGroupAssignmentByID 1

.NOTES
No notes
#>
function Get-NBCircuitGroupAssignmentByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitGroupAssignmentsAPIPath -id $id

}