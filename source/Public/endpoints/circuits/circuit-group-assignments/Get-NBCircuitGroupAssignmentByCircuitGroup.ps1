function Get-NBCircuitGroupAssignmentByCircuitGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitGroupAssignmentsAPIPath -field 'group_id' -value $id).results
}