<#
.SYNOPSIS
Get a circuit type by ID number

.DESCRIPTION
Get a circuit type by ID number

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to modify
#>
function Get-NBCircuitTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitTypesAPIPath -id $id

}