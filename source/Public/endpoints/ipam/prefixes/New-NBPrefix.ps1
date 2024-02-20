function New-NBPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$prefix,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$vlan,
		[Parameter(Mandatory=$false)]
			[ValidateSet('container','active','reserved','deprecated')]
			[int]$status,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][bool]$is_pool,
		[Parameter(Mandatory=$false)][bool]$mark_utilized,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$PrefixesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}