<#
.SYNOPSIS
Gets circuit group assignments by circuit group ID

.DESCRIPTION
Gets circuit group assignments by circuit group ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the circuit group

.EXAMPLE
Get-NBCircuitGroupAssignmentByCircuitGroup 1

.NOTES
No Notes
#>
function Get-NBCircuitGroupAssignmentByCircuitGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitGroupAssignmentsAPIPath -field 'group_id' -value $id).results
}