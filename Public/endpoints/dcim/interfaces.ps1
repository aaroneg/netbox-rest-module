Class NBDeviceInterface {
	[string]$name
	[string]$type

	# Constructor
	NBDeviceInterface(
		[string]$name,
		[string]$type
	){
		$this.name = $name
		$this.type = $type
	}
}
$NBDeviceInterfaceAPIPath="dcim/interfaces"

function New-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]$type,
		[Parameter(Mandatory=$true,Position=2)][int]$deviceID,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBDeviceInterface]::New($name,$type)
	if ($deviceID) { $PostObject | Add-Member -MemberType NoteProperty -Name device -Value $deviceID }

	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceInterfaceAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	$postJSON = $PostObject|ConvertTo-Json -Depth 50
	Write-Verbose $postJSON
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBDeviceInterfaces {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath
}

function Get-NBDeviceInterfaceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -id $id
}

function Get-NBDeviceInterfaceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -value $name
}

function Find-NBDeviceInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -name $name).results
}

function Set-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','device','module','label','type','enabled','parent','bridge','lag','mtu','mac_address','speed',
				'duplex','wwn','mgmt_only','description','mode','rf_role','rf_channel','poe_mode','poe_type','rf_channel_frequency',
				'rf_channel_width','tx_power','untagged_vlan','tagged_vlans','mark_connected','cable','wireless_link','vrf')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBDeviceInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}
