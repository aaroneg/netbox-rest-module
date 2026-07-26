<#
.SYNOPSIS
Get an object by ID

.DESCRIPTION
Get an object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of the object to retrieve
#>
function Get-NBVirtualCircuitTerminationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBVirtualCircuitTerminationsAPIPath -id $id

}