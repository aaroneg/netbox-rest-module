<#
.SYNOPSIS
Find objects with name including string

.DESCRIPTION
Find objects with name including string

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Text string to search for in Name field
#>
function Find-NBManufacturersContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ManufacturerAPIPath -name $name

}