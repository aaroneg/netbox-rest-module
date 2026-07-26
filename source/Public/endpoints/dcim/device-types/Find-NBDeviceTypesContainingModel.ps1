<#
.SYNOPSIS
Get device types containing a string

.DESCRIPTION
Get device types containing a string

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER model
String to look for in a 'contains' query

.EXAMPLE
Find-NBDeviceTypesContainingModel 'PowerEdge'
#>
function Find-NBDeviceTypesContainingModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$model
	)
	Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ic' -value $model

}