function New-NBCircuitGroupAssignment {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$group,
		[Parameter(Mandatory=$true,Position=1)][int]$circuit,
		[Parameter(Mandatory=$false)][string][ValidateSet('primary','secondary','tertiary','inactive')]$priority,
		[Parameter(Mandatory=$false)][string[]]$tags,
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