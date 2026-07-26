<#
.SYNOPSIS
Delete a termination object by ID

.DESCRIPTION
Delete a termination object by ID

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The ID number of the termination to remove

.EXAMPLE
An example

.NOTES
General notes
#>
function Remove-NBCircuitTermination {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTerminationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}