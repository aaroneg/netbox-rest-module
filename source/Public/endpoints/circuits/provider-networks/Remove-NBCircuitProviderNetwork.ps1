<#
.SYNOPSIS
Remove a provider network object

.DESCRIPTION
Remove a provider network object

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the object to remove
#>
function Remove-NBCircuitProviderNetwork {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProviderNetworksAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}