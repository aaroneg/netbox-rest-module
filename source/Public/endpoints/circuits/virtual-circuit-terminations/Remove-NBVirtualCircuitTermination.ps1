<#
.SYNOPSIS
Remove termination object

.DESCRIPTION
Remove termination object

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-NBVirtualCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualCircuitTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}