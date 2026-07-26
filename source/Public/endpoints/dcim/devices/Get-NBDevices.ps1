<#
.SYNOPSIS
Get devices of type

.DESCRIPTION
Get devices of type

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBDevices {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DevicesAPIPath

}