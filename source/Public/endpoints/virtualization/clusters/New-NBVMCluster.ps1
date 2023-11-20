function New-NBVMCluster {
	<#
	.SYNOPSIS
	Creates a new virtual machine cluster object
	.PARAMETER name
	Name of the object
	.PARAMETER type
	ID of the type object
	.PARAMETER group
	ID of the group object
	.PARAMETER tenant
	ID of the tenant object
	.PARAMETER site
	ID of the site object
	.PARAMETER comments
	Any comments you would like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$type,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string]$status="active",
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if (!($PSBoundParameters.ContainsKey('status'))) {$PSBoundParameters.add('status', $status)}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClustersAPIPath/"
		body = $PostJson
	}
	$PostObject= Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}