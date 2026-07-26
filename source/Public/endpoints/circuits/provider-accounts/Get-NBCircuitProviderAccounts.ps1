<#
.SYNOPSIS
Get all circuit provider accounts

.DESCRIPTION
Get all circuit provider accounts

.PARAMETER Connection
The connection object to use, if not using default.

.NOTES
The number of objects returned may not reflect the full list of objects, if you hit a built-in API limit.
#>
function Get-NBCircuitProviderAccounts {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBCircuitProviderAccountsAPIPath

}