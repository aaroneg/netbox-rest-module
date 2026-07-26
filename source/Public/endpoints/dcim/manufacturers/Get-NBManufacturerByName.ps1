<#
.SYNOPSIS
Get object by Name

.DESCRIPTION
Get object by Name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Name of object to return
#>
function Get-NBManufacturerByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ManufacturerAPIPath -value $name

}