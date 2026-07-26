<#
.SYNOPSIS
Remove object by ID

.DESCRIPTION
Remove object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to remove
#>
function Remove-NBRackType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBRackTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}