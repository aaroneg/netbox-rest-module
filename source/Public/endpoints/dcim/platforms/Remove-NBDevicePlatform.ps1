<#
.SYNOPSIS
Remove object by ID

.DESCRIPTION
Remove object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to remove

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-NBDevicePlatform {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$DevicePlatformAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}