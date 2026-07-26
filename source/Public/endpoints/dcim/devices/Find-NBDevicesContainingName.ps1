<#
.SYNOPSIS
Find objects containing name

.DESCRIPTION
Find objects containing name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Name string to search for
#>
function Find-NBDevicesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $DevicesAPIPath -name $name

}