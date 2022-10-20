$NBWirelessLanAPIPath="wireless/wireless-lans"

function New-NBWirelessLan {
	<#
	.SYNOPSIS
	Adds a new wireless lan object to Netbox
	.PARAMETER ssid
	The SSID of the wireless LAN
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER group
	This is the *group object ID*, which you should obtain before running this command with `Get-NBWirelessLanGroupByName`
	.PARAMETER vlan
	This is the *vlan object ID*, not the actual vlan number. You can obtain this ID with `Get-NBVLANByName` or `Get-NBVLANByVID`
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

	# It's probably not a good practice to make this too smart - the function should reflect the API as best it can, but it is 
	# certainly confusing that both the vlan and the vlan id are ints, and it's not immediately clear whether it's asking for 
	# the vlan number or the vlan ID.
	#	$PSBoundParameters['vlan']=(Get-NBVLANByVID -Connection $Connection -vid $vlan).id
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanAPIPath/"
		body = $PostJson
	}
	Invoke-CustomRequest -restParams $restParams -Connection $Connection
}

function Get-NBWirelessLans {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath
}

function Get-NBWirelessLanByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath -id $id
}

function Get-NBWirelessLanBySSID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$SSID
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath -field ssid -value $SSID
}

function Set-NBWirelessLan {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('ssid','description','group','vlan','tenant','auth_type','auth_cipher','auth_psk')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBWirelessLan {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
