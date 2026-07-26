<#
.SYNOPSIS
Remove a circuit provider object by ID

.DESCRIPTION
Remove a circuit provider object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The object ID to remove
#>
function Remove-NBCircuitProvider {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProvidersAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}