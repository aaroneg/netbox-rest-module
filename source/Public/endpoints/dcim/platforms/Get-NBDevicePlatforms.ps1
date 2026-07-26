<#
.SYNOPSIS
Get objects of type

.DESCRIPTION
Get objects of type

.PARAMETER Connection
The connection object to use, if not using default.

.NOTES
CMDlet may not return all items, subject to API limits
#>
function Get-NBDevicePlatforms {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DevicePlatformAPIPath

}