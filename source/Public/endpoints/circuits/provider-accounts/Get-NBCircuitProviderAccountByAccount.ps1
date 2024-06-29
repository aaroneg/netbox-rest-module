function Get-NBCircuitProviderAccountByAccount {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$account
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBCircuitProviderAccountsAPIPath -field account -value $account).results

}