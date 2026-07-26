<#
.SYNOPSIS
Get Device by ID

.DESCRIPTION
Get Device by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to return
#>
function Get-NBDevicePlatformByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $DevicePlatformAPIPath -id $id

}