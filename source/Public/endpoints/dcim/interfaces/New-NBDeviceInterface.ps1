function New-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=2)][int]$device,	
		[Parameter(Mandatory=$false)][int]$module,	
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateSet("virtual","bridge","lag","100base-fx","100base-lfx","100base-tx","100base-t1","1000base-t",
				"1000base-lx","1000base-tx","2.5gbase-t","5gbase-t","10gbase-t","10gbase-cx4","100base-x-sfp",
				"1000base-x-gbic","1000base-x-sfp","10gbase-x-sfpp","10gbase-x-xfp","10gbase-x-xenpak","10gbase-x-x2",
				"25gbase-x-sfp28","50gbase-x-sfp56","40gbase-x-qsfpp","50gbase-x-sfp28","100gbase-x-cfp",
				"100gbase-x-cfp2","200gbase-x-cfp2","400gbase-x-cfp2","100gbase-x-cfp4","100gbase-x-cxp",
				"100gbase-x-cpak","100gbase-x-dsfp","100gbase-x-sfpdd","100gbase-x-qsfp28","100gbase-x-qsfpdd",
				"200gbase-x-qsfp56","200gbase-x-qsfpdd","400gbase-x-qsfp112","400gbase-x-qsfpdd","400gbase-x-osfp",
				"400gbase-x-osfp-rhs","400gbase-x-cdfp","400gbase-x-cfp8","800gbase-x-qsfpdd","800gbase-x-osfp",
				"1000base-kx","2.5gbase-kx","5gbase-kr","10gbase-kr","10gbase-kx4","25gbase-kr","40gbase-kr4",
				"50gbase-kr","100gbase-kp4","100gbase-kr2","100gbase-kr4","ieee802.11a","ieee802.11g","ieee802.11n",
				"ieee802.11ac","ieee802.11ad","ieee802.11ax","ieee802.11ay","ieee802.11be","ieee802.15.1",
				"ieee802.15.4","other-wireless","gsm","cdma","lte","4g","5g","sonet-oc3","sonet-oc12","sonet-oc48",
				"sonet-oc192","sonet-oc768","sonet-oc1920","sonet-oc3840","1gfc-sfp","2gfc-sfp","4gfc-sfp",
				"8gfc-sfpp","16gfc-sfpp","32gfc-sfp28","32gfc-sfpp","64gfc-qsfpp","64gfc-sfpdd","64gfc-sfpp",
				"128gfc-qsfp28","infiniband-sdr","infiniband-ddr","infiniband-qdr","infiniband-fdr10","infiniband-fdr",
				"infiniband-edr","infiniband-hdr","infiniband-ndr","infiniband-xdr","t1","e1","t3","e3","xdsl","docsis",
				"bpon","epon","10g-epon","gpon","xg-pon","xgs-pon","ng-pon2","25g-pon","50g-pon","cisco-stackwise",
				"cisco-stackwise-plus","cisco-flexstack","cisco-flexstack-plus","cisco-stackwise-80","cisco-stackwise-160",
				"cisco-stackwise-320","cisco-stackwise-480","cisco-stackwise-1t","juniper-vcp","extreme-summitstack",
				"extreme-summitstack-128","extreme-summitstack-256","extreme-summitstack-512","other")]
			[string]$type,
		[Parameter(Mandatory=$false)][bool]$enabled,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][int]$bridge,
		[Parameter(Mandatory=$false)][int]$lag,
		[Parameter(Mandatory=$false)][int]$mtu,
		[Parameter(Mandatory=$false)][string]$mac_address,
		[Parameter(Mandatory=$false)][int]$speed,
		[Parameter(Mandatory=$false)][string]$duplex,
		[Parameter(Mandatory=$false)][string]$wwn,
		[Parameter(Mandatory=$false)][bool]$mgmt_only,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$mode,
		[Parameter(Mandatory=$false)][string]$rf_role,
		[Parameter(Mandatory=$false)][string]$rf_channel,
		[Parameter(Mandatory=$false)][string]$poe_mode,
		[Parameter(Mandatory=$false)][string]$poe_type,
		[Parameter(Mandatory=$false)][int]$rf_channel_frequency,
		[Parameter(Mandatory=$false)][int]$rf_channel_width,
		[Parameter(Mandatory=$false)][int]$tx_power,
		[Parameter(Mandatory=$false)][int]$untagged_vlan,
		[Parameter(Mandatory=$false)][int[]]$tagged_vlans,
		[Parameter(Mandatory=$false)][switch]$mark_connected,
		[Parameter(Mandatory=$false)][int[]]$wireless_lans,
		[Parameter(Mandatory=$false)][int]$vrf,
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