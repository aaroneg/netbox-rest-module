<#
.SYNOPSIS
Get device by ID

.DESCRIPTION
Get device by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
Object ID
#>
function Get-NBDeviceInterfaceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -id $id

}