function New-NBWirelessLink {
	<#
	.SYNOPSIS
	Adds a new virtual machine object to Netbox
	.PARAMETER interface_a
	The id of interface object A
	.PARAMETER interface_b
	The id of interface object B
	.PARAMETER ssid
	The SSID string of the connection
	.PARAMETER status
	The applicable lifecycle status of this object
	.PARAMETER tenant
	The id of the tenant object
	.PARAMETER auth_type 
	The authentication type
	.PARAMETER auth_cipher
	The authentication cipher
	.PARAMETER auth_psk
	The pre-shared key
	.PARAMETER description
	A description of the objects
	.PARAMETER comments
	Any comments you have on the object
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$interface_a,
		[Parameter(Mandatory=$true,Position=1)][int]$interface_b,
		[Parameter(Mandatory=$false)][string]$ssid,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('connected','planned','decommissioning')]
			$status,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('open','wep','wpa-personal','wpa-enterprise')]
			$auth_type,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('auto','tkip','aes')]
			$auth_cipher,
		[Parameter(Mandatory=$false)][string]$auth_psk,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLinkAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}