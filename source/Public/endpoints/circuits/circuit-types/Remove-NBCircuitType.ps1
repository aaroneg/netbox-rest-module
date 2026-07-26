<#
.SYNOPSIS
Remove a connection type by ID

.DESCRIPTION
Remove a connection type by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The object ID to remove
#>
function Remove-NBCircuitType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}