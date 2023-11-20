function New-NBWirelessLan {
	<#
	.SYNOPSIS
	Adds a new wireless lan object to Netbox
	.PARAMETER ssid
	The SSID of the wireless LAN
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER group
	Group object ID
	.PARAMETER vlan
	VLAN object ID
	.PARAMETER auth_type
	Authentication type
	.PARAMETER auth_cipher
	Authentication cipher
	.PARAMETER auth_psk
	Authentication pre-shared key
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$ssid,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$vlan,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('open','wep','wpa-personal','wpa-enterprise')]
		# Authentication Type
		$auth_type,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('auto','tkip','aes')]
		# Authentication Cipher
		$auth_cipher,
		[Parameter(Mandatory=$false)][string]
		# Authentication pre-shared key, if applicable. maxlength: 64
		$auth_psk,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}