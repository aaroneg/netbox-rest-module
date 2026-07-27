<#
.SYNOPSIS
Create a new device interface

.DESCRIPTION
Create a new device interface

.PARAMETER device
Object ID for device

.PARAMETER vdcs
Array of virtual device object IDs

.PARAMETER module
Module Object ID

.PARAMETER name
Name, as reported by OS ex: eth0

.PARAMETER label
Physical label, ex: 0

.PARAMETER type
Port type - either 'virtual','bridge','lag' or one of a large number of types that change with each Netbox release. See API docs for full list of values, or set one device the way you like it, and run `get-NBDeviceInterfaceByID` with that interface ID to get the correct value.

.PARAMETER enabled
$true if the interface is enabled.

.PARAMETER parent
Parent device object ID

.PARAMETER bridge
Parent bridge object ID

.PARAMETER lag
Parent LAG object ID

.PARAMETER mtu
MTU size

.PARAMETER primary_mac_address
MAC address object ID if it is already assigned to this interface.

.PARAMETER speed
Speed, measured in Kbps

.PARAMETER duplex
Duplex value, autocomplete enabled

.PARAMETER wwn
WWN id

.PARAMETER mgmt_only
$true if the interface is only used for management.

.PARAMETER description
Description

.PARAMETER mode
802.1Q tagging mode, autocomplete enabled

.PARAMETER rf_role
'ap' or 'station'

.PARAMETER rf_channel
RF channel. Use the WebUI to set the channel, then use that value. There are many valid values.

.PARAMETER poe_mode
'pd' or 'pse' at time of writing

.PARAMETER poe_type
Use WebUI to set the value you want once, then use `Get-NBDeviceInterfaceByID` to get the API value.

.PARAMETER rf_channel_frequency
RF Channel Frequency

.PARAMETER rf_channel_width
RF Channel Width

.PARAMETER tx_power
Transmit power in dBm

.PARAMETER untagged_vlan
Untagged vlan object ID - not actual VLAN number

.PARAMETER tagged_vlans
Tagged vlan object IDs - not actual VLAN numbers

.PARAMETER qinq_svlan
ID number of Q-in-Q Service VLAN object

.PARAMETER vlan_translation_policy
ID of VLAN translation policy object.

.PARAMETER mark_connected
$true if the interface should be treated as a connected object.

.PARAMETER wireless_lans
Wireles Lan Object IDs

.PARAMETER vrf
VRF object ID

.PARAMETER owner
Owner object ID

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=2)][int]$device,	
		[Parameter(Mandatory=$false)][int[]]$vdcs,	
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
		[Parameter(Mandatory=$false)][ValidateSet('pd','pse')][string]$poe_mode,
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