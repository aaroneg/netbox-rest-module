<#
.SYNOPSIS
Get device types containing a string

.DESCRIPTION
Get device types containing a string

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
String to look for in a 'contains' query
#>
function Find-NBRegionsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $regionsAPIPath -name $name

}