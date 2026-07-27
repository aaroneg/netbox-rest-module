<#
.SYNOPSIS
Create new Wireless Lan

.DESCRIPTION
Create new Wireless Lan

.PARAMETER ssid
SSID name

.PARAMETER description
Description

.PARAMETER group
Object ID for Wireless Lan Group

.PARAMETER status
Lifecycle Status, autocomplete enabled

.PARAMETER vlan
Object ID for VLAN

.PARAMETER scope_type
Type of object this WLAN will attach to

.PARAMETER scope_id
Object ID for scope

.PARAMETER tenant
Object ID for tenant

.PARAMETER auth_type
Authentication type

.PARAMETER auth_cipher
Authentication Cipher

.PARAMETER auth_psk
Authentication pre-shared key

.PARAMETER owner
Object ID for owner

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBWirelessLan {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$ssid,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][string]
			[ValidateSet('active','reserved','disabled','deprecated')]
			# Authentication Type
			$status,
		[Parameter(Mandatory=$false)][int]$vlan,
		[Parameter(Mandatory=$false)][ValidateSet('dcim.location','dcim.region','dcim.site','dcim.sitegroup')][string]$scope_type,
		[Parameter(Mandatory=$false)][int]$scope_id,
		[Parameter(Mandatory=$false)][int]$tenant,
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
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
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