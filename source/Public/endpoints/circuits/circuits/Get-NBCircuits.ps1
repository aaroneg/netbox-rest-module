<#
.SYNOPSIS
Get all circuit objects

.DESCRIPTION
Get all circuit objects

.PARAMETER Connection
The connection object to use, if not using default.
#>
function Get-NBCircuits {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitsAPIPath

}