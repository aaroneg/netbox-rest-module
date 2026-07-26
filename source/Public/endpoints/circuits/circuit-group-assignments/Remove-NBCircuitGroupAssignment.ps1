<#
.SYNOPSIS
Remove an assignment

.DESCRIPTION
Remove an assignment

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
The id of the assignment

.EXAMPLE
Remove-NBCircuitGroupAssignment 1

.NOTES
No notes
#>
function Remove-NBCircuitGroupAssignment {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitGroupAssignmentsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}