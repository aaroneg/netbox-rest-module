<#
.SYNOPSIS
Get a circuit group by id number

.DESCRIPTION
Get a circuit group by id number

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the circuit group

.NOTES
No notes
#>
function Get-NBCircuitGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitGroupsAPIPath -id $id

}