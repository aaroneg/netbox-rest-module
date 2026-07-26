<#
.SYNOPSIS
Get Circuit provider account object by ID

.DESCRIPTION
Get Circuit provider account object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the provider account object
#>
function Get-NBCircuitProviderAccountByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBCircuitProviderAccountsAPIPath -id $id

}