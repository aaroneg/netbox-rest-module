<#
.SYNOPSIS
Remove a circuit by ID

.DESCRIPTION
Remove a circuit by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID of the object to remove

#>
function Remove-NBCircuit {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}