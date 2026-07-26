<#
.SYNOPSIS
Change an assignment type and id to new values

.DESCRIPTION
Change an assignment type and id to new values

.PARAMETER Connection
The connection object to use, if not using default.

.PARAMETER id
ID of object to modify

.PARAMETER member_type
'circuits.circuit' OR 'circuits.virtualcircuit'

.PARAMETER member_id
The id of the circuit or virtual circuit object
#>
function Set-NBCircuitGroupAssignmentTypeAndID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		# ValidateSets updated as of Netbox v4.1.8
		[Parameter(Mandatory=$true,Position=1)][string][ValidateSet('circuits.circuit','circuits.virtualcircuit')]$member_type,
		[Parameter(Mandatory=$true,Position=2)][int]$member_id
	)
	$update=@{
		member_type = "$member_type"
		member_id = $member_id
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitGroupAssignmentsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}