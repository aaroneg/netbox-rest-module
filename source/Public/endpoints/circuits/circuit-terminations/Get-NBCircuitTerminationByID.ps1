<#
.SYNOPSIS
Get a circuit termination by ID number

.DESCRIPTION
Get a circuit termination by ID number

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the object

.EXAMPLE
Get-NBCircuitTerminationByID 1

.NOTES
No notes
#>
function Get-NBCircuitTerminationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitTerminationsAPIPath -id $id

}