<#
.SYNOPSIS
Get objects by type

.DESCRIPTION
Get objects by type

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBConsolePorts {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBConsolePortsAPIPath
}