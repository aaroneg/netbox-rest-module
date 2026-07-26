<#
.SYNOPSIS
Get object by ID

.DESCRIPTION
Get object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to return
#>
function Get-NBManufacturerByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ManufacturerAPIPath -id $id

}