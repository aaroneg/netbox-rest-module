function New-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=2)][int]$device,	
		[Parameter(Mandatory=$false)][int]$module,	
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$true,Position=1)][string]$type,
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