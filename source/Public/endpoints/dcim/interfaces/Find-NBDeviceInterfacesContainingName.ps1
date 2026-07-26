<#
.SYNOPSIS
Find objects containing name

.DESCRIPTION
Find objects containing name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Name to look for

.EXAMPLE
An example

.NOTES
General notes
#>
function Find-NBDeviceInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -name $name).results

}