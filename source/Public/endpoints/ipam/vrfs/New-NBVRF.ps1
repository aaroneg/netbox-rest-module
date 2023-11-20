function New-NBVRF {
	<#
	.SYNOPSIS
	Creates a VRF object
	.PARAMETER name
	Name of the object
	.PARAMETER rd
	Route distinguisher
	.PARAMETER tenant
	Tenant id
	.PARAMETER enforce_unique
	Enforce unique IP addresses in this VRF
	.PARAMETER description
	Description
	.PARAMETER comments
	Comments
	.PARAMETER Connection
	Connection object
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$rd,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][bool]$enforce_unique,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VRFsApiPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}