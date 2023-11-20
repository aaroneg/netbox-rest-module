function New-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$address,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)]
			[ValidateSet('active','reserved','deprecated','dhcp','slaac')]
			[string]$status,
		[Parameter(Mandatory=$false)]
			[ValidateSet('loopback','secondary','anycast','vip','vrrp','hsrp','glbp','carp')]
			[string]$role,
		[Parameter(Mandatory=$false)][string]$assigned_object_type,
		[Parameter(Mandatory=$false)][int]$assigned_object_id,
		[Parameter(Mandatory=$false)][int]$nat_inside,
		[Parameter(Mandatory=$false)][string]$dns_name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}