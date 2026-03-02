function New-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=2)][int]$device,	
		[Parameter(Mandatory=$false)][int]$vdcs,	
		[Parameter(Mandatory=$false)][int]$module,	
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$true,Position=1)]
			# They keep adding more types of interfaces, just going to punt this to the API to throw errors back if there are any.
			[string]$type,
		[Parameter(Mandatory=$false)][bool]$enabled,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][int]$bridge,
		[Parameter(Mandatory=$false)][int]$lag,
		[Parameter(Mandatory=$false)][int]$mtu,
		[Parameter(Mandatory=$false)][int]$primary_mac_address,
		#[Parameter(Mandatory=$false)][string]$mac_address, # MAC addresses moved to their own object around Netbox 4.2
		[Parameter(Mandatory=$false)][int]$speed,
		[Parameter(Mandatory=$false)][ValidateSet('half','full','auto')]$duplex,
		[Parameter(Mandatory=$false)][string]$wwn,
		[Parameter(Mandatory=$false)][bool]$mgmt_only,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][ValidateSet('access','tagged','tagged-all','q-in-q')][string]$mode,
		[Parameter(Mandatory=$false)][string]$rf_role,
		[Parameter(Mandatory=$false)][string]$rf_channel,
		[Parameter(Mandatory=$false)][string]$poe_mode,
		[Parameter(Mandatory=$false)][string]$poe_type,
		[Parameter(Mandatory=$false)][int]$rf_channel_frequency,
		[Parameter(Mandatory=$false)][int]$rf_channel_width,
		[Parameter(Mandatory=$false)][int]$tx_power,
		[Parameter(Mandatory=$false)][int]$untagged_vlan,
		[Parameter(Mandatory=$false)][int[]]$tagged_vlans,
		[Parameter(Mandatory=$false)][int]$qinq_svlan,
		[Parameter(Mandatory=$false)][int]$vlan_translation_policy,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][int[]]$wireless_lans,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceInterfaceAPIPath/"
		body = $PostJson
	}
	Write-Verbose $PostJson
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}