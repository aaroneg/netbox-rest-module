<#
.SYNOPSIS
Remove a provider account object

.DESCRIPTION
Remove a provider account object

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The object id to remove
#>
function Remove-NBCircuitProviderAccount {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProviderAccountsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}