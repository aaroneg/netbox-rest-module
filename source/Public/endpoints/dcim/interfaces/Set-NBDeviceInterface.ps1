function Set-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('device','vdcs','module','name','label','type','enabled','parent','bridge','lag','mtu','mac_address','speed',
				'duplex','wwn','mgmt_only','description','mode','rf_role','rf_channel','poe_mode','poe_type','rf_channel_frequency',
				'rf_channel_width','tx_power','untagged_vlan','tagged_vlans','mark_connected','wireless_lans','vrf','tags','custom_fields')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=processFieldUpdates $key $value
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}