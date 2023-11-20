function New-NBVLAN {
	<#
	.SYNOPSIS
	Creates a vlan object
	.PARAMETER name
	Name of the object
	.PARAMETER vid 
	vlan id number
	.PARAMETER status
	status of the vlan
	.PARAMETER site
	site id
	.PARAMETER group
	group id
	.PARAMETER tenant
	tenant id
	.PARAMETER role
	role id
	.PARAMETER description
	vlan description
	.PARAMETER comments
	comments
	.PARAMETER Connection
	connection object
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$vid,
		[Parameter(Mandatory=$false,Position=2)]
			[ValidateSet('active','reserved','deprecated')]
			[string]$status="active",
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if (!($PSBoundParameters.ContainsKey('status'))) {$PSBoundParameters.add('status', $status)}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}