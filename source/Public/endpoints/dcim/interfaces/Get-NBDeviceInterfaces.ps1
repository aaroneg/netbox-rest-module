<#
.SYNOPSIS
Get all objects of type

.DESCRIPTION
Get all objects of type

.PARAMETER Connection
The connection object to use, if not using default.

.NOTES
You may not get all objects if this endpoint is coded with a hard limit.
#>
function Get-NBDeviceInterfaces {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath

}