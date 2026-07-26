<#
.SYNOPSIS
Find objects containing string

.DESCRIPTION
Find objects containing string

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
String to search for
#>
function Find-NBLocationsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $LocationsAPIPath -name $name).results

}