<#
.SYNOPSIS
Create a new circuit group assignment

.DESCRIPTION
Create a new circuit group assignment

.PARAMETER group
The ID of the group to add a circuit to

.PARAMETER circuit
The ID of the circuit object you'd like to assign

.PARAMETER priority
The priority of the assignment

.PARAMETER tags
Tag ID[s]

.PARAMETER custom_fields
A hash table of custom fields

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
New-NBCircuitGroupAssignment 1 1 -priority primary

.NOTES
No notes
#>
function New-NBCircuitGroupAssignment {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$group,
		[Parameter(Mandatory=$true,Position=1)][int]$circuit,
		[Parameter(Mandatory=$false)][string][ValidateSet('primary','secondary','tertiary','inactive')]$priority,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitGroupAssignmentsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}