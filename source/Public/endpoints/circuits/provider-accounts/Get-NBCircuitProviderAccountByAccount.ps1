<#
.SYNOPSIS
Get the object for a provider account by name/identifier

.DESCRIPTION
Get the object for a provider account by name/identifier

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER account
Account name or identifier
#>
function Get-NBCircuitProviderAccountByAccount {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$account
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitProviderAccountsAPIPath -field account -value $account).results

}