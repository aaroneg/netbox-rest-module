function New-NBDevice {
	<#
	.SYNOPSIS
	Adds a new device object to Netbox
	#>
	[CmdletBinding()]
	# ValidateSets updated as of Netbox v4.1.8
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$device_type,
		[Parameter(Mandatory=$true,Position=2)][int]$role,
		[Parameter(Mandatory=$false,Position=3)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][string]$asset_tag,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$location,
		[Parameter(Mandatory=$false)][int]$rack,
		[Parameter(Mandatory=$false)][int]$position,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front','rear')]
			[string]$face,
		[Parameter(Mandatory=$false)][double]$latitude,
		[Parameter(Mandatory=$false)][double]$longitude,
		[Parameter(Mandatory=$false)]
			[ValidateSet('offline','active','planned','staged','failed','inventory','decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','rear-to-side','bottom-to-top','top-to-bottom','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$primary_ip4,
		[Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false)][int]$oob_ip,
		[Parameter(Mandatory=$false)][int]$cluster,
		[Parameter(Mandatory=$false)][int]$virtual_chassis,
		[Parameter(Mandatory=$false)][int]$vc_position,
		[Parameter(Mandatory=$false)][int]$vc_priority,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$MACAddressAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}