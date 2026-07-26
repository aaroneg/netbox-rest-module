<#
.SYNOPSIS
Get all interfaces attached to a device ID

.DESCRIPTION
Get all interfaces attached to a device ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of device
#>
function Get-NBDeviceInterfaceForDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -field 'device_id' $id).results

}