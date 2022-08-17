Class NBDevice {
	[string]$name
	[int]$device_type
	[int]$device_role
	[int]$site
	[string]$face
	# Constructor
	NBDevice(
		[string]$name,
		[int]$device_type,
		[int]$device_role,
		[int]$site,
		[string]$face
	){
		$this.name = $name
		$this.device_type = $device_type
		$this.device_role = $device_role
		$this.site = $site
		$this.face = $face
	}
}
$DevicesAPIPath="dcim/devices"

function New-NBDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$device_typeID,
		[Parameter(Mandatory=$true,Position=2)][int]$device_roleID,
		[Parameter(Mandatory=$true,Position=3)][int]$siteID,
		[Parameter(Mandatory=$true,Position=4)][string]
			[ValidateSet('front','rear')]
			$face,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBDevice]::New($name,$device_typeID,$device_roleID,$siteID,$face)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBDevices {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DevicesAPIPath
}

function Get-NBDeviceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $DevicesAPIPath -id $id
}

function Get-NBDeviceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $DevicesAPIPath -value $name
}

function Find-NBDevicesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $DevicesAPIPath -name $name
}

function Set-NBDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','device_type','device_role','tenant','platform','serial','asset_tag','site',
				'location','rack','position','face','parent_device','status','airflow','primary_ipv4',
				'primary_ipv6','cluster','virtual_chassis','vc_position','vc_priority','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}