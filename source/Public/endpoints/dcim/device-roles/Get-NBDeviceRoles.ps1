<#
.SYNOPSIS
Get all objects of type

.DESCRIPTION
Get all objects of type

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBDeviceRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DeviceRolesAPIPath

}