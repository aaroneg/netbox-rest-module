<#
.SYNOPSIS
Get object by name

.DESCRIPTION
Get object by name

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER name
Object Name
#>
function Get-NBDeviceRoleByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $DeviceRolesAPIPath -value $name

}