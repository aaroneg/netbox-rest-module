<#
.SYNOPSIS
Get objects of type

.DESCRIPTION
Get objects of type

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBManufacturers {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ManufacturerAPIPath

}