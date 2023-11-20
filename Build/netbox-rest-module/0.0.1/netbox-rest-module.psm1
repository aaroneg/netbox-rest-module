#Region '.\Private\added-fields.ps1' 0
function createPostJson {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][object]$Fields
	)
	$CurrentObject=New-Object -TypeName System.Object
	$Fields | ForEach-Object {
		$_.key | Out-Host
		$_.value | Out-Host
		$CurrentObject | Add-Member -MemberType NoteProperty -Name $_.key -Value $_.value
	}
	createJson($CurrentObject)
}
function createJson ($Object) { $Object | ConvertTo-Json -Depth 50 }
#EndRegion '.\Private\added-fields.ps1' 15
#Region '.\Private\api-items.ps1' 0
function Get-APIItemByQuery {
	[CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$field,
		[parameter(Mandatory = $true)][string]$value
    )
	$QueryArguments= @{
		$field = $value
	}
	$ArgumentString= New-ArgumentString $QueryArguments
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/?$ArgumentString"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API search call using '$field' looking for '$value'."
    Invoke-CustomRequest $restParams -Connection $Connection
}
function Find-ApiItemsContainingName {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name
    )
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Attempting to find items containing '$Name'."
    Get-APIItemByQuery -apiConnection $apiConnection -field 'name__ic' -value $Name -RelativePath $RelativePath
}

function Get-APIItemByName {
	[CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
		[parameter(Mandatory = $true)][string]$value
    )
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Attempting to find item named '$Name'."
	(Get-APIItemByQuery -apiConnection $apiConnection -field 'name__ie' -value $value -RelativePath $RelativePath).results
}

function Get-ApiItemByID {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$id
    )
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/$id/"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    Invoke-CustomRequest $restParams -Connection $Connection
}


function Get-ApiItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:Connection,
        [parameter(Mandatory = $true)][string]$RelativePath
    )
	$arguments = @{
		limit = 5000
	}
	$argumentString=[System.Web.HttpUtility]::ParseQueryString('')
	$arguments.GetEnumerator() | ForEach-Object {$argumentString.Add($_.Key, $_.Value)}
	$argumentString=$argumentString.ToString()
    $restParams = @{
        Method               = 'get'
        URI                  = "$($Connection.ApiBaseURL)/$RelativePath/?$argumentString"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
	# # (Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
    (Invoke-CustomRequest $restParams -Connection $apiConnection).results
}
#EndRegion '.\Private\api-items.ps1' 79
#Region '.\Private\Invoke-CustomRequest.ps1' 0
function Invoke-CustomRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $True, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		Authorization = "Token $($Connection.ApiKey)"
		"Content-Type"    = 'application/json'
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers -SkipCertificateCheck
	}
	catch {
		if ($_.ErrorDetails.Message) {
			$_.ErrorDetails
			#Write-Error "Response from $($Connection.Address): $(($_.ErrorDetails.Message).message)."
		}
		else {
			$_.ErrorDetails.Message
		}
	}
	$result
}
#EndRegion '.\Private\Invoke-CustomRequest.ps1' 26
#Region '.\Private\New-ArgumentString.ps1' 0
function New-ArgumentString {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][hashtable]$QueryArguments
	)
	$OutputString = [System.Web.HttpUtility]::ParseQueryString('')
	$QueryArguments.GetEnumerator() | ForEach-Object { $OutputString.Add($_.Key, $_.Value) }
	$OutputString.ToString()
}
#EndRegion '.\Private\New-ArgumentString.ps1' 10
#Region '.\Private\slug.ps1' 0
function makeSlug ([string]$name) {
	$name.ToLower() -Replace("[^\w ]+","") -replace " +","-" -replace "^-",'' -replace "-$",''
}
#EndRegion '.\Private\slug.ps1' 4
#Region '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoleByID.ps1' 0
function Get-NBDeviceRoleByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $DeviceRolesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoleByID.ps1' 10
#Region '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoleByName.ps1' 0
function Get-NBDeviceRoleByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $DeviceRolesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoleByName.ps1' 10
#Region '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoles.ps1' 0
function Get-NBDeviceRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DeviceRolesAPIPath

}
#EndRegion '.\Public\endpoints\dcim\device-roles\Get-NBDeviceRoles.ps1' 9
#Region '.\Public\endpoints\dcim\device-roles\New-NBDeviceRole.ps1' 0
function New-NBDeviceRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]$color,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DeviceRolesAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\device-roles\New-NBDeviceRole.ps1' 21
#Region '.\Public\endpoints\dcim\device-roles\Remove-NBDeviceRole.ps1' 0
function Remove-NBDeviceRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$DeviceRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\device-roles\Remove-NBDeviceRole.ps1' 15
#Region '.\Public\endpoints\dcim\device-roles\Set-NBDeviceRole.ps1' 0
function Set-NBDeviceRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','color','vm_role','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$DeviceRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\device-roles\Set-NBDeviceRole.ps1' 26
#Region '.\Public\endpoints\dcim\device-types\Find-NBDeviceTypesContainingModel.ps1' 0
function Find-NBDeviceTypesContainingModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$model
	)
	Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ic' -value $model

}
#EndRegion '.\Public\endpoints\dcim\device-types\Find-NBDeviceTypesContainingModel.ps1' 10
#Region '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypeByID.ps1' 0
function Get-NBDeviceTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $deviceTypesPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypeByID.ps1' 10
#Region '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypeByModel.ps1' 0
function Get-NBDeviceTypeByModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$model
	)
	(Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ie' -value $model).results

}
#EndRegion '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypeByModel.ps1' 10
#Region '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypes.ps1' 0
function Get-NBDeviceTypes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $deviceTypesPath

}
#EndRegion '.\Public\endpoints\dcim\device-types\Get-NBDeviceTypes.ps1' 9
#Region '.\Public\endpoints\dcim\device-types\New-NBDeviceType.ps1' 0
function New-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$manufacturer,
		[Parameter(Mandatory=$false)][int]$default_platform,
		[Parameter(Mandatory=$true,Position=1)][string]$model,
		[Parameter(Mandatory=$true,Position=1)][string]$part_number,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][bool]$is_full_depth,
		[Parameter(Mandatory=$true,Position=1)][string]$subdevice_role,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		[Parameter(Mandatory=$false)][string]$front_image,
		[Parameter(Mandatory=$false)][string]$rear_image,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\device-types\New-NBDeviceType.ps1' 38
#Region '.\Public\endpoints\dcim\device-types\Remove-NBDeviceType.ps1' 0
function Remove-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\device-types\Remove-NBDeviceType.ps1' 15
#Region '.\Public\endpoints\dcim\device-types\Set-NBDeviceType.ps1' 0
function Set-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('manufacturer','model','slug','part_number','u_height','is_full_depth','subdevice_role','airflow',
			'comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\device-types\Set-NBDeviceType.ps1' 27
#Region '.\Public\endpoints\dcim\devices\Find-NBDevicesContainingName.ps1' 0
function Find-NBDevicesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $DevicesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\devices\Find-NBDevicesContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\devices\Get-NBDeviceByID.ps1' 0
function Get-NBDeviceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $DevicesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\devices\Get-NBDeviceByID.ps1' 10
#Region '.\Public\endpoints\dcim\devices\Get-NBDeviceByName.ps1' 0
function Get-NBDeviceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $DevicesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\devices\Get-NBDeviceByName.ps1' 10
#Region '.\Public\endpoints\dcim\devices\Get-NBDevices.ps1' 0
function Get-NBDevices {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DevicesAPIPath

}
#EndRegion '.\Public\endpoints\dcim\devices\Get-NBDevices.ps1' 9
#Region '.\Public\endpoints\dcim\devices\New-NBDevice.ps1' 0
function New-NBDevice {
	<#
	.SYNOPSIS
	Adds a new device object to Netbox
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$device_type,
		[Parameter(Mandatory=$true,Position=2)][int]$role,
		[Parameter(Mandatory=$true,Position=3)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][string]$asset_tag,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$location,
		[Parameter(Mandatory=$false)][int]$rack,
		[Parameter(Mandatory=$false)][int]$postition,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front','rear')]
			[string]$face,
		[Parameter(Mandatory=$false)][int]$latitude,
		[Parameter(Mandatory=$false)][int]$longitude,
		[Parameter(Mandatory=$false)]
			[ValidateSet('offline','active','planned','staged','failed','inventory','decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$primary_ip4,
		[Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false)][int]$oop_ip,
		[Parameter(Mandatory=$false)][int]$cluster,
		[Parameter(Mandatory=$false)][int]$virtual_chassis,
		[Parameter(Mandatory=$false)][int]$vc_position,
		[Parameter(Mandatory=$false)][int]$vc_priority,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int]$config_template,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\devices\New-NBDevice.ps1' 55
#Region '.\Public\endpoints\dcim\devices\Remove-NBDevice.ps1' 0
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
#EndRegion '.\Public\endpoints\dcim\devices\Remove-NBDevice.ps1' 15
#Region '.\Public\endpoints\dcim\devices\Set-NBDevice.ps1' 0
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
#EndRegion '.\Public\endpoints\dcim\devices\Set-NBDevice.ps1' 24
#Region '.\Public\endpoints\dcim\interfaces\Find-NBDeviceInterfacesContainingName.ps1' 0
function Find-NBDeviceInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -name $name).results

}
#EndRegion '.\Public\endpoints\dcim\interfaces\Find-NBDeviceInterfacesContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaceByID.ps1' 0
function Get-NBDeviceInterfaceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaceByID.ps1' 10
#Region '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaceByName.ps1' 0
function Get-NBDeviceInterfaceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaceByName.ps1' 10
#Region '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaces.ps1' 0
function Get-NBDeviceInterfaces {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBDeviceInterfaceAPIPath

}
#EndRegion '.\Public\endpoints\dcim\interfaces\Get-NBDeviceInterfaces.ps1' 9
#Region '.\Public\endpoints\dcim\interfaces\New-NBDeviceInterface.ps1' 0
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
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	$postJSON = $PostObject|ConvertTo-Json -Depth 50
	Write-Verbose $postJSON
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\interfaces\New-NBDeviceInterface.ps1' 45
#Region '.\Public\endpoints\dcim\interfaces\Remove-NBDeviceInterface.ps1' 0
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
#EndRegion '.\Public\endpoints\dcim\interfaces\Remove-NBDeviceInterface.ps1' 15
#Region '.\Public\endpoints\dcim\interfaces\Set-NBDeviceInterface.ps1' 0
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
#EndRegion '.\Public\endpoints\dcim\interfaces\Set-NBDeviceInterface.ps1' 24
#Region '.\Public\endpoints\dcim\locations\Find-NBLocationsContainingName.ps1' 0
function Find-NBLocationsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $LocationsAPIPath -name $name).results

}
#EndRegion '.\Public\endpoints\dcim\locations\Find-NBLocationsContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\locations\Get-NBLocationByID.ps1' 0
function Get-NBLocationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $LocationsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\locations\Get-NBLocationByID.ps1' 10
#Region '.\Public\endpoints\dcim\locations\Get-NBLocationByName.ps1' 0
function Get-NBLocationByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $LocationsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\locations\Get-NBLocationByName.ps1' 10
#Region '.\Public\endpoints\dcim\locations\Get-NBLocations.ps1' 0
function Get-NBLocations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $LocationsAPIPath

}
#EndRegion '.\Public\endpoints\dcim\locations\Get-NBLocations.ps1' 9
#Region '.\Public\endpoints\dcim\locations\New-NBLocation.ps1' 0
function New-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$site,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)]
			[ValidateSet('planned','staging','active','decommissioning','retired')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\locations\New-NBLocation.ps1' 29
#Region '.\Public\endpoints\dcim\locations\Remove-NBLocation.ps1' 0
function Remove-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\locations\Remove-NBLocation.ps1' 15
#Region '.\Public\endpoints\dcim\locations\Set-NBLocation.ps1' 0
function Set-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','site','parent','status','tenant','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\locations\Set-NBLocation.ps1' 22
#Region '.\Public\endpoints\dcim\manufacturers\Find-NBManufacturersContainingName.ps1' 0
function Find-NBManufacturersContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ManufacturerAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Find-NBManufacturersContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturerByID.ps1' 0
function Get-NBManufacturerByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ManufacturerAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturerByID.ps1' 10
#Region '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturerByName.ps1' 0
function Get-NBManufacturerByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ManufacturerAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturerByName.ps1' 10
#Region '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturers.ps1' 0
function Get-NBManufacturers {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ManufacturerAPIPath

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Get-NBManufacturers.ps1' 9
#Region '.\Public\endpoints\dcim\manufacturers\New-NBManufacturer.ps1' 0
function New-NBManufacturer {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ManufacturerAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\New-NBManufacturer.ps1' 23
#Region '.\Public\endpoints\dcim\manufacturers\Remove-NBManufacturer.ps1' 0
function Remove-NBManufacturer {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ManufacturerAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Remove-NBManufacturer.ps1' 15
#Region '.\Public\endpoints\dcim\manufacturers\Set-NBManufacturer.ps1' 0
function Set-NBManufacturer {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$ManufacturerAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\manufacturers\Set-NBManufacturer.ps1' 26
#Region '.\Public\endpoints\dcim\platforms\Find-NBDevicePlatformsContainingName.ps1' 0
function Find-NBDevicePlatformsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $DevicePlatformAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\platforms\Find-NBDevicePlatformsContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\platforms\Find-NBDeviceRolesContainingName.ps1' 0
function Find-NBDeviceRolesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $DeviceRolesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\platforms\Find-NBDeviceRolesContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatformByID.ps1' 0
function Get-NBDevicePlatformByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $DevicePlatformAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatformByID.ps1' 10
#Region '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatformByName.ps1' 0
function Get-NBDevicePlatformByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $DevicePlatformAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatformByName.ps1' 10
#Region '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatforms.ps1' 0
function Get-NBDevicePlatforms {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $DevicePlatformAPIPath

}
#EndRegion '.\Public\endpoints\dcim\platforms\Get-NBDevicePlatforms.ps1' 9
#Region '.\Public\endpoints\dcim\platforms\New-NBDevicePlatform.ps1' 0
function New-NBDevicePlatform {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$manufacturer,
		[Parameter(Mandatory=$false)][int]$config_template,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DevicePlatformAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\platforms\New-NBDevicePlatform.ps1' 25
#Region '.\Public\endpoints\dcim\platforms\Remove-NBDevicePlatform.ps1' 0
function Remove-NBDevicePlatform {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$DevicePlatformAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\platforms\Remove-NBDevicePlatform.ps1' 15
#Region '.\Public\endpoints\dcim\platforms\Set-NBDevicePlatform.ps1' 0
function Set-NBDevicePlatform {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','manufacturer','napalm_driver','napalm_args','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$DevicePlatformAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\platforms\Set-NBDevicePlatform.ps1' 26
#Region '.\Public\endpoints\dcim\rack-elevations\Get-NBRackElevation.ps1' 0
function Get-NBRackElevation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/$id/elevation/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results

}
#EndRegion '.\Public\endpoints\dcim\rack-elevations\Get-NBRackElevation.ps1' 14
#Region '.\Public\endpoints\dcim\rack-reservations\Get-NBRackReservationByID.ps1' 0
function Get-NBRackReservationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RackReservationsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\rack-reservations\Get-NBRackReservationByID.ps1' 10
#Region '.\Public\endpoints\dcim\rack-reservations\Get-NBRackReservations.ps1' 0
function Get-NBRackReservations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RackReservationsAPIPath

}
#EndRegion '.\Public\endpoints\dcim\rack-reservations\Get-NBRackReservations.ps1' 9
#Region '.\Public\endpoints\dcim\rack-reservations\New-NBRackReservation.ps1' 0
function New-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$rack,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateRange(0,32767)]
			[int]$units,
		[Parameter(Mandatory=$true,Position=3)][int]$user,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$true,Position=4)][string]$description,
		[Parameter(Mandatory=$false)][int]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\rack-reservations\New-NBRackReservation.ps1' 27
#Region '.\Public\endpoints\dcim\rack-reservations\Remove-NBRackReservation.ps1' 0
function Remove-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\rack-reservations\Remove-NBRackReservation.ps1' 15
#Region '.\Public\endpoints\dcim\rack-reservations\Set-NBRackReservation.ps1' 0
function Set-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('rack','units','user','tenant','description','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\rack-reservations\Set-NBRackReservation.ps1' 26
#Region '.\Public\endpoints\dcim\rack-roles\Find-NBRackRolesContainingName.ps1' 0
function Find-NBRackRolesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $RackRolesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Find-NBRackRolesContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoleByID.ps1' 0
function Get-NBRackRoleByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RackRolesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoleByID.ps1' 10
#Region '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoleByName.ps1' 0
function Get-NBRackRoleByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $RackRolesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoleByName.ps1' 10
#Region '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoles.ps1' 0
function Get-NBRackRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RackRolesAPIPath

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Get-NBRackRoles.ps1' 9
#Region '.\Public\endpoints\dcim\rack-roles\New-NBRackRole.ps1' 0
function New-NBRackRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\New-NBRackRole.ps1' 24
#Region '.\Public\endpoints\dcim\rack-roles\Remove-NBRackRole.ps1' 0
function Remove-NBRackRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Remove-NBRackRole.ps1' 15
#Region '.\Public\endpoints\dcim\rack-roles\Set-NBRackRole.ps1' 0
function Set-NBRackRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','color','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\rack-roles\Set-NBRackRole.ps1' 26
#Region '.\Public\endpoints\dcim\racks\Find-NBRacksContainingName.ps1' 0
function Find-NBRacksContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $RacksAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\racks\Find-NBRacksContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\racks\Get-NBRackByID.ps1' 0
function Get-NBRackByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RacksAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\racks\Get-NBRackByID.ps1' 10
#Region '.\Public\endpoints\dcim\racks\Get-NBRackByName.ps1' 0
function Get-NBRackByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $RacksAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\racks\Get-NBRackByName.ps1' 10
#Region '.\Public\endpoints\dcim\racks\Get-NBRacks.ps1' 0
function Get-NBRacks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RacksAPIPath

}
#EndRegion '.\Public\endpoints\dcim\racks\Get-NBRacks.ps1' 9
#Region '.\Public\endpoints\dcim\racks\New-NBRack.ps1' 0
function New-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$facility_id,
		[Parameter(Mandatory=$true,Position=1)][int]$site,
		[Parameter(Mandatory=$true,Position=1)][int]$tenant,
		[Parameter(Mandatory=$false)]
			[ValidateSet('reserved','available','planned','active','deprecated')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][string]$asset_tag,
		[Parameter(Mandatory=$false)]
			[ValidateSet('2-post-frame','4-post-frame','4-post-cabinet','wall-frame','wall-frame-vertical','wall-cabinet','wall-cabinet-vertical')]
			[string]$type,
		[Parameter(Mandatory=$false)][int]$width,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][int]$starting_unit,
		[Parameter(Mandatory=$false)][int]$weight,
		[Parameter(Mandatory=$false)][int]$max_weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		[Parameter(Mandatory=$false)][bool]$desc_units,
		[Parameter(Mandatory=$false)][int]$outer_width,
		[Parameter(Mandatory=$false)][int]$outer_depth,
		[Parameter(Mandatory=$false)]
			[ValidateSet('mm','in')]
			[string]$outer_unit,
		[Parameter(Mandatory=$false)][int]$mounting_depth,
		[Parameter(Mandatory=$true,Position=2)][int]$location,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBRack]::New($name,$siteID,$locationID)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\racks\New-NBRack.ps1' 51
#Region '.\Public\endpoints\dcim\racks\Remove-NBRack.ps1' 0
function Remove-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\racks\Remove-NBRack.ps1' 15
#Region '.\Public\endpoints\dcim\racks\Set-NBRack.ps1' 0
function Set-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','facility_id','site','location','tenant','status',
			'role','serial','asset_tag','type','width','u_height','starting_unit',
			'weight','max_weight','weight_unit','desc_units','outer_width','outer_depth',
			'outer_unit','mounting_depth','description','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\racks\Set-NBRack.ps1' 29
#Region '.\Public\endpoints\dcim\regions\Find-NBRegionsContainingName.ps1' 0
function Find-NBRegionsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $regionsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\regions\Find-NBRegionsContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\regions\Get-NBRegionByID.ps1' 0
function Get-NBRegionByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $regionsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\regions\Get-NBRegionByID.ps1' 10
#Region '.\Public\endpoints\dcim\regions\Get-NBRegionByName.ps1' 0
function Get-NBRegionByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $regionsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\regions\Get-NBRegionByName.ps1' 10
#Region '.\Public\endpoints\dcim\regions\Get-NBRegions.ps1' 0
function Get-NBRegions {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $regionsAPIPath

}
#EndRegion '.\Public\endpoints\dcim\regions\Get-NBRegions.ps1' 9
#Region '.\Public\endpoints\dcim\regions\New-NBRegion.ps1' 0
function New-NBRegion {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$regionsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\regions\New-NBRegion.ps1' 24
#Region '.\Public\endpoints\dcim\regions\Remove-NBRegion.ps1' 0
function Remove-NBRegion {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$regionsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\regions\Remove-NBRegion.ps1' 15
#Region '.\Public\endpoints\dcim\regions\Set-NBRegion.ps1' 0
function Set-NBRegion {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','parent','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$regionsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\regions\Set-NBRegion.ps1' 26
#Region '.\Public\endpoints\dcim\site-groups\Find-NBSiteGroupsContainingName.ps1' 0
function Find-NBSiteGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $SiteGroupsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Find-NBSiteGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroupByID.ps1' 0
function Get-NBSiteGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $SiteGroupsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroupByID.ps1' 10
#Region '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroupByName.ps1' 0
function Get-NBSiteGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $SiteGroupsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroupByName.ps1' 10
#Region '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroups.ps1' 0
function Get-NBSiteGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $SiteGroupsAPIPath

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Get-NBSiteGroups.ps1' 9
#Region '.\Public\endpoints\dcim\site-groups\New-NBSiteGroup.ps1' 0
function New-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\site-groups\New-NBSiteGroup.ps1' 23
#Region '.\Public\endpoints\dcim\site-groups\Remove-NBSiteGroup.ps1' 0
function Remove-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Remove-NBSiteGroup.ps1' 15
#Region '.\Public\endpoints\dcim\site-groups\Set-NBSiteGroup.ps1' 0
function Set-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description','parent')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\site-groups\Set-NBSiteGroup.ps1' 26
#Region '.\Public\endpoints\dcim\sites\Find-NBSitesContainingName.ps1' 0
function Find-NBSitesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $SitesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\sites\Find-NBSitesContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\sites\Get-NBSiteByID.ps1' 0
function Get-NBSiteByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $SitesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\sites\Get-NBSiteByID.ps1' 10
#Region '.\Public\endpoints\dcim\sites\Get-NBSiteByName.ps1' 0
function Get-NBSiteByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $SitesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\sites\Get-NBSiteByName.ps1' 10
#Region '.\Public\endpoints\dcim\sites\Get-NBSites.ps1' 0
function Get-NBSites {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $SitesAPIPath

}
#EndRegion '.\Public\endpoints\dcim\sites\Get-NBSites.ps1' 9
#Region '.\Public\endpoints\dcim\sites\New-NBSite.ps1' 0
function New-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('planned','staging','active','decommissioning','retired')]
			$status,
		[Parameter(Mandatory=$false)][int]$region,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$facility,
		[Parameter(Mandatory=$false)][string]$time_zone,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$physical_address,
		[Parameter(Mandatory=$false)][string]$shipping_address,
		[Parameter(Mandatory=$false)][int]$latitude,
		[Parameter(Mandatory=$false)][int]$longitude,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostObject=[NBsite]::New($name,$status)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\sites\New-NBSite.ps1' 36
#Region '.\Public\endpoints\dcim\sites\Remove-NBSite.ps1' 0
function Remove-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\sites\Remove-NBSite.ps1' 15
#Region '.\Public\endpoints\dcim\sites\Set-NBSite.ps1' 0
function Set-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','status','region','group','tenant','facility','time_zone','description','physical_address','shipping_address','latitude','longitude','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\sites\Set-NBSite.ps1' 26
#Region '.\Public\endpoints\dcim\virtual-chassis\Find-NBVirtualChassisContainingName.ps1' 0
function Find-NBVirtualChassisContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBVirtualChassisAPIPath -name $name

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Find-NBVirtualChassisContainingName.ps1' 10
#Region '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassis.ps1' 0
function Get-NBVirtualChassis {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBVirtualChassisAPIPath

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassis.ps1' 9
#Region '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassisByID.ps1' 0
function Get-NBVirtualChassisByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBVirtualChassisAPIPath -id $id

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassisByID.ps1' 10
#Region '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassisByName.ps1' 0
function Get-NBVirtualChassisByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBVirtualChassisAPIPath -value $name

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Get-NBVirtualChassisByName.ps1' 10
#Region '.\Public\endpoints\dcim\virtual-chassis\New-NBVirtualChassis.ps1' 0
function New-NBVirtualChassis {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$domain,
		[Parameter(Mandatory=$false)][int]$master,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBVirtualChassis]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualChassisAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\New-NBVirtualChassis.ps1' 25
#Region '.\Public\endpoints\dcim\virtual-chassis\Remove-NBVirtualChassis.ps1' 0
function Remove-NBVirtualChassis {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualChassisAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Remove-NBVirtualChassis.ps1' 15
#Region '.\Public\endpoints\dcim\virtual-chassis\Set-NBVirtualChassis.ps1' 0
function Set-NBVirtualChassis {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','domain','master','description','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualChassisAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\dcim\virtual-chassis\Set-NBVirtualChassis.ps1' 26
#Region '.\Public\endpoints\ipam\aggregates\Get-NBAggregateByID.ps1' 0
function Get-NBAggregateByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBAggregateAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\aggregates\Get-NBAggregateByID.ps1' 10
#Region '.\Public\endpoints\ipam\aggregates\Get-NBAggregateByPrefix.ps1' 0
function Get-NBAggregateByPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$prefix
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBAggregateAPIPath -field prefix -value $prefix

}
#EndRegion '.\Public\endpoints\ipam\aggregates\Get-NBAggregateByPrefix.ps1' 10
#Region '.\Public\endpoints\ipam\aggregates\Get-NBAggregates.ps1' 0
function Get-NBAggregates {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBAggregateAPIPath

}
#EndRegion '.\Public\endpoints\ipam\aggregates\Get-NBAggregates.ps1' 9
#Region '.\Public\endpoints\ipam\aggregates\New-NBAggregate.ps1' 0
function New-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$prefix,
		[Parameter(Mandatory=$true,Position=1)][int]$rir,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$date_added,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\aggregates\New-NBAggregate.ps1' 26
#Region '.\Public\endpoints\ipam\aggregates\Remove-NBAggregate.ps1' 0
function Remove-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\aggregates\Remove-NBAggregate.ps1' 15
#Region '.\Public\endpoints\ipam\aggregates\Set-NBAggregate.ps1' 0
function Set-NBAggregate {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('prefix','rir','tenant','date_added','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBAggregateAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\aggregates\Set-NBAggregate.ps1' 26
#Region '.\Public\endpoints\ipam\asns\Find-NBASNsContainingName.ps1' 0
function Find-NBASNsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$asn
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ASNsAPIPath -name $asn

}
#EndRegion '.\Public\endpoints\ipam\asns\Find-NBASNsContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\asns\Get-NBASNByID.ps1' 0
function Get-NBASNByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ASNsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\asns\Get-NBASNByID.ps1' 10
#Region '.\Public\endpoints\ipam\asns\Get-NBASNByName.ps1' 0
function Get-NBASNByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$asn
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ASNsAPIPath -value $asn

}
#EndRegion '.\Public\endpoints\ipam\asns\Get-NBASNByName.ps1' 10
#Region '.\Public\endpoints\ipam\asns\Get-NBASNs.ps1' 0
function Get-NBASNs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ASNsAPIPath

}
#EndRegion '.\Public\endpoints\ipam\asns\Get-NBASNs.ps1' 9
#Region '.\Public\endpoints\ipam\asns\New-NBASN.ps1' 0
function New-NBASN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$asn,
		[Parameter(Mandatory=$true,Position=0)][int]$rir,
		[Parameter(Mandatory=$true,Position=0)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ASNsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\asns\New-NBASN.ps1' 25
#Region '.\Public\endpoints\ipam\asns\Remove-NBASN.ps1' 0
function Remove-NBASN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ASNsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\asns\Remove-NBASN.ps1' 15
#Region '.\Public\endpoints\ipam\asns\Set-NBASN.ps1' 0
function Set-NBASN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('asn','rir','tenant','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$ASNsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\asns\Set-NBASN.ps1' 26
#Region '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddressByID.ps1' 0
function Get-NBIPAddressByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPAddressAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddressByID.ps1' 11
#Region '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddressByName.ps1' 0
function Get-NBIPAddressByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItemByName -apiConnection $Connection -RelativePath $IPAddressAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddressByName.ps1' 11
#Region '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddresses.ps1' 0
function Get-NBIPAddresses {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	Get-ApiItems -apiConnection $Connection -RelativePath $IPAddressAPIPath

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Get-NBIPAddresses.ps1' 10
#Region '.\Public\endpoints\ipam\ip-addresses\New-NBIPAddress.ps1' 0
function New-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$address,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)]
			[ValidateSet('active','reserved','deprecated','dhcp','slaac')]
			[string]$status,
		[Parameter(Mandatory=$false)]
			[ValidateSet('loopback','secondary','anycast','vip','vrrp','hsrp','glbp','carp')]
			[string]$role,
		[Parameter(Mandatory=$false)][string]$assigned_object_type,
		[Parameter(Mandatory=$false)][int]$assigned_object_id,
		[Parameter(Mandatory=$false)][int]$nat_inside,
		[Parameter(Mandatory=$false)][string]$dns_name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\New-NBIPAddress.ps1' 36
#Region '.\Public\endpoints\ipam\ip-addresses\Remove-NBIPAddress.ps1' 0
function Remove-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Remove-NBIPAddress.ps1' 16
#Region '.\Public\endpoints\ipam\ip-addresses\Set-NBIPAddress.ps1' 0
function Set-NBIPAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('address','vrf','tenant','status','role','nat_inside','dns_name','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Set-NBIPAddress.ps1' 23
#Region '.\Public\endpoints\ipam\ip-addresses\Set-NBIPAddressParent.ps1' 0
function Set-NBIPAddressParent {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('dcim.interface','virtualization.vminterface')]
			$InterFaceType,
		[Parameter(Mandatory=$true,Position=2)][string]$interface
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)]"
	$update=@{
		assigned_object_type = "$InterFaceType"
		assigned_object_id = $interface
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPAddressAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\ip-addresses\Set-NBIPAddressParent.ps1' 24
#Region '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRangeByID.ps1' 0
function Get-NBIPRangeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPRangesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRangeByID.ps1' 10
#Region '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRangeByName.ps1' 0
function Get-NBIPRangeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $IPRangesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRangeByName.ps1' 10
#Region '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRanges.ps1' 0
function Get-NBIPRanges {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $IPRangesAPIPath

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\Get-NBIPRanges.ps1' 9
#Region '.\Public\endpoints\ipam\ip-ranges\New-NBIPRange.ps1' 0
function New-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$start_address,
		[Parameter(Mandatory=$true,Position=1)][string]$end_address,
		[Parameter(Mandatory=$true,Position=2)][string][ValidateSet('active','reserved','deprecated')]$status,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\New-NBIPRange.ps1' 28
#Region '.\Public\endpoints\ipam\ip-ranges\Remove-NBIPRange.ps1' 0
function Remove-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\Remove-NBIPRange.ps1' 15
#Region '.\Public\endpoints\ipam\ip-ranges\Set-NBIPRange.ps1' 0
function Set-NBIPRange {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('start_address','end_address','vrf','tenant','status','role','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPRangesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\ip-ranges\Set-NBIPRange.ps1' 22
#Region '.\Public\endpoints\ipam\prefixes\Get-NBPrefixByID.ps1' 0
function Get-NBPrefixByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $PrefixesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\prefixes\Get-NBPrefixByID.ps1' 10
#Region '.\Public\endpoints\ipam\prefixes\Get-NBPrefixes.ps1' 0
function Get-NBPrefixes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $PrefixesAPIPath

}
#EndRegion '.\Public\endpoints\ipam\prefixes\Get-NBPrefixes.ps1' 9
#Region '.\Public\endpoints\ipam\prefixes\New-NBPrefix.ps1' 0
function New-NBPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$prefix,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$vlan,
		[Parameter(Mandatory=$false)]
			[ValidateSet('container','active','reserved','deprecated')]
			[int]$status,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][bool]$is_pool,
		[Parameter(Mandatory=$false)][bool]$mark_utilized,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$PrefixesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\prefixes\New-NBPrefix.ps1' 33
#Region '.\Public\endpoints\ipam\prefixes\Remove-NBPrefix.ps1' 0
function Remove-NBPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$PrefixesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\prefixes\Remove-NBPrefix.ps1' 15
#Region '.\Public\endpoints\ipam\prefixes\Set-NBPrefix.ps1' 0
function Set-NBPrefix {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('prefix','site','vrf','tenant','vlan','role','is_pool','mark_utilized',
			'description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$PrefixesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\prefixes\Set-NBPrefix.ps1' 23
#Region '.\Public\endpoints\ipam\rirs\Find-NBRIRsContainingName.ps1' 0
function Find-NBRIRsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $RIRsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\ipam\rirs\Find-NBRIRsContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\rirs\Get-NBRIRByID.ps1' 0
function Get-NBRIRByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RIRsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\rirs\Get-NBRIRByID.ps1' 10
#Region '.\Public\endpoints\ipam\rirs\Get-NBRIRByName.ps1' 0
function Get-NBRIRByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $RIRsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\rirs\Get-NBRIRByName.ps1' 10
#Region '.\Public\endpoints\ipam\rirs\Get-NBRIRs.ps1' 0
function Get-NBRIRs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RIRsAPIPath

}
#EndRegion '.\Public\endpoints\ipam\rirs\Get-NBRIRs.ps1' 9
#Region '.\Public\endpoints\ipam\rirs\New-NBRIR.ps1' 0
function New-NBRIR {
	<#
	.SYNOPSIS
	Creates a new RIR
	.PARAMETER name
	RIR Name
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RIRsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\rirs\New-NBRIR.ps1' 30
#Region '.\Public\endpoints\ipam\rirs\Remove-NBRIR.ps1' 0
function Remove-NBRIR {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$RIRsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\rirs\Remove-NBRIR.ps1' 15
#Region '.\Public\endpoints\ipam\rirs\Set-NBRIR.ps1' 0
function Set-NBRIR {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','is_private','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$RIRsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\rirs\Set-NBRIR.ps1' 26
#Region '.\Public\endpoints\ipam\roles\Find-NBIPAMRolesContainingName.ps1' 0
function Find-NBIPAMRolesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $IPAMRolesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\ipam\roles\Find-NBIPAMRolesContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\roles\Get-NBIPAMRoleByID.ps1' 0
function Get-NBIPAMRoleByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $IPAMRolesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\roles\Get-NBIPAMRoleByID.ps1' 10
#Region '.\Public\endpoints\ipam\roles\Get-NBIPAMRoleByName.ps1' 0
function Get-NBIPAMRoleByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $IPAMRolesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\roles\Get-NBIPAMRoleByName.ps1' 10
#Region '.\Public\endpoints\ipam\roles\Get-NBIPAMRoles.ps1' 0
function Get-NBIPAMRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $IPAMRolesAPIPath

}
#EndRegion '.\Public\endpoints\ipam\roles\Get-NBIPAMRoles.ps1' 9
#Region '.\Public\endpoints\ipam\roles\New-NBIPAMRole.ps1' 0
function New-NBIPAMRole {
	<#
	.SYNOPSIS
	Creates a new IPAM role
	.PARAMETER name
	Name of role
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$IPAMRolesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\roles\New-NBIPAMRole.ps1' 30
#Region '.\Public\endpoints\ipam\roles\Remove-NBIPAMRole.ps1' 0
function Remove-NBIPAMRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$IPAMRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\roles\Remove-NBIPAMRole.ps1' 15
#Region '.\Public\endpoints\ipam\roles\Set-NBIPAMRole.ps1' 0
function Set-NBIPAMRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','weight','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$IPAMRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\roles\Set-NBIPAMRole.ps1' 22
#Region '.\Public\endpoints\ipam\vlan-groups\Find-NBVlanGroupsContainingName.ps1' 0
function Find-NBVlanGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	(Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $vlangroupsAPIPath -name $name).results

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Find-NBVlanGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroupByID.ps1' 0
function Get-NBVlanGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $vlangroupsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroupByID.ps1' 10
#Region '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroupByName.ps1' 0
function Get-NBVlanGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $vlangroupsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroupByName.ps1' 10
#Region '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroups.ps1' 0
function Get-NBVlanGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $vlangroupsAPIPath

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Get-NBVlanGroups.ps1' 9
#Region '.\Public\endpoints\ipam\vlan-groups\New-NBVlanGroup.ps1' 0
function New-NBVlanGroup {
	<#
	.SYNOPSIS
	Add a new vlan group
	.PARAMETER name
	vlan group name
	.PARAMETER Connection
	Connection object
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$vlangroupsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\New-NBVlanGroup.ps1' 30
#Region '.\Public\endpoints\ipam\vlan-groups\Remove-NBVlanGroup.ps1' 0
function Remove-NBVlanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$vlangroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Remove-NBVlanGroup.ps1' 15
#Region '.\Public\endpoints\ipam\vlan-groups\Set-NBVlanGroup.ps1' 0
function Set-NBVlanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','scope_type','scope_id','min_vid','max_vid','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$vlangroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vlan-groups\Set-NBVlanGroup.ps1' 22
#Region '.\Public\endpoints\ipam\vlans\Find-NBVLANsContainingName.ps1' 0
function Find-NBVLANsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VLANsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\ipam\vlans\Find-NBVLANsContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\vlans\Get-NBVLANByID.ps1' 0
function Get-NBVLANByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VLANsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\vlans\Get-NBVLANByID.ps1' 10
#Region '.\Public\endpoints\ipam\vlans\Get-NBVLANByName.ps1' 0
function Get-NBVLANByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VLANsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\vlans\Get-NBVLANByName.ps1' 10
#Region '.\Public\endpoints\ipam\vlans\Get-NBVLANByVID.ps1' 0
function Get-NBVLANByVID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$vid
	)
	(Get-APIItemByQuery -apiConnection $Connection -RelativePath $VLANsAPIPath -field vid -value $vid).results

}
#EndRegion '.\Public\endpoints\ipam\vlans\Get-NBVLANByVID.ps1' 10
#Region '.\Public\endpoints\ipam\vlans\Get-NBVLANs.ps1' 0
function Get-NBVLANs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VLANsAPIPath

}
#EndRegion '.\Public\endpoints\ipam\vlans\Get-NBVLANs.ps1' 9
#Region '.\Public\endpoints\ipam\vlans\New-NBVLAN.ps1' 0
function New-NBVLAN {
	<#
	.SYNOPSIS
	Creates a vlan object
	.PARAMETER name
	Name of the object
	.PARAMETER vid 
	vlan id number
	.PARAMETER status
	status of the vlan
	.PARAMETER site
	site id
	.PARAMETER group
	group id
	.PARAMETER tenant
	tenant id
	.PARAMETER role
	role id
	.PARAMETER description
	vlan description
	.PARAMETER comments
	comments
	.PARAMETER Connection
	connection object
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$vid,
		[Parameter(Mandatory=$false,Position=2)]
			[ValidateSet('active','reserved','deprecated')]
			[string]$status="active",
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if (!($PSBoundParameters.ContainsKey('status'))) {$PSBoundParameters.add('status', $status)}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\vlans\New-NBVLAN.ps1' 55
#Region '.\Public\endpoints\ipam\vlans\Remove-NBVLAN.ps1' 0
function Remove-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vlans\Remove-NBVLAN.ps1' 15
#Region '.\Public\endpoints\ipam\vlans\Set-NBVLAN.ps1' 0
function Set-NBVLAN {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('site','group','vid','name','tenant','status',
			'role','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VLANsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vlans\Set-NBVLAN.ps1' 23
#Region '.\Public\endpoints\ipam\vrfs\Find-NBVRFsContainingName.ps1' 0
function Find-NBVRFsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VRFsApiPath -name $name

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Find-NBVRFsContainingName.ps1' 10
#Region '.\Public\endpoints\ipam\vrfs\Get-NBVRFByID.ps1' 0
function Get-NBVRFByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VRFsApiPath -id $id

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Get-NBVRFByID.ps1' 10
#Region '.\Public\endpoints\ipam\vrfs\Get-NBVRFByName.ps1' 0
function Get-NBVRFByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VRFsApiPath -value $name

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Get-NBVRFByName.ps1' 10
#Region '.\Public\endpoints\ipam\vrfs\Get-NBVRFs.ps1' 0
function Get-NBVRFs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VRFsApiPath

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Get-NBVRFs.ps1' 9
#Region '.\Public\endpoints\ipam\vrfs\New-NBVRF.ps1' 0
function New-NBVRF {
	<#
	.SYNOPSIS
	Creates a VRF object
	.PARAMETER name
	Name of the object
	.PARAMETER rd
	Route distinguisher
	.PARAMETER tenant
	Tenant id
	.PARAMETER enforce_unique
	Enforce unique IP addresses in this VRF
	.PARAMETER description
	Description
	.PARAMETER comments
	Comments
	.PARAMETER Connection
	Connection object
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$rd,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][bool]$enforce_unique,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VRFsApiPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\ipam\vrfs\New-NBVRF.ps1' 44
#Region '.\Public\endpoints\ipam\vrfs\Remove-NBVRF.ps1' 0
function Remove-NBVRF {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VRFsApiPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Remove-NBVRF.ps1' 15
#Region '.\Public\endpoints\ipam\vrfs\Set-NBVRF.ps1' 0
function Set-NBVRF {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','rd','tenant','enforce_unique','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VRFsApiPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\ipam\vrfs\Set-NBVRF.ps1' 22
#Region '.\Public\endpoints\status\Get-NBStatus.ps1' 0
function Get-NBStatus {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$StatusAPIPath/"
	}	
	Invoke-CustomRequest -restParams $restParams -Connection $Connection

}
#EndRegion '.\Public\endpoints\status\Get-NBStatus.ps1' 13
#Region '.\Public\endpoints\tenancy\Find-NBContactGroupsContainingName.ps1' 0
function Find-NBContactGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\tenancy\Find-NBContactGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\tenancy\Find-NBContactRolesContainingName.ps1' 0
function Find-NBContactRolesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ContactRolesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\tenancy\Find-NBContactRolesContainingName.ps1' 10
#Region '.\Public\endpoints\tenancy\Find-NBContactsContainingName.ps1' 0
function Find-NBContactsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ContactsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\tenancy\Find-NBContactsContainingName.ps1' 10
#Region '.\Public\endpoints\tenancy\Find-NBTenantGroupsContainingName.ps1' 0
function Find-NBTenantGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $TenantGroupsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\tenancy\Find-NBTenantGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\tenancy\Find-NBTenantsContainingName.ps1' 0
function Find-NBTenantsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $TenantsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\tenancy\Find-NBTenantsContainingName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactByID.ps1' 0
function Get-NBContactByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ContactsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactByID.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactByName.ps1' 0
function Get-NBContactByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ContactsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactByName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactGroupByID.ps1' 0
function Get-NBContactGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactGroupByID.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactGroupByName.ps1' 0
function Get-NBContactGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactGroupByName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactGroups.ps1' 0
function Get-NBContactGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ContactGroupsAPIPath

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactGroups.ps1' 9
#Region '.\Public\endpoints\tenancy\Get-NBContactRoleByID.ps1' 0
function Get-NBContactRoleByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ContactRolesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactRoleByID.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactRoleByName.ps1' 0
function Get-NBContactRoleByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ContactRolesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactRoleByName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBContactRoles.ps1' 0
function Get-NBContactRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ContactRolesAPIPath

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContactRoles.ps1' 9
#Region '.\Public\endpoints\tenancy\Get-NBContacts.ps1' 0
function Get-NBContacts {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ContactsAPIPath

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBContacts.ps1' 9
#Region '.\Public\endpoints\tenancy\Get-NBTenantByID.ps1' 0
function Get-NBTenantByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $TenantsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenantByID.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBTenantByName.ps1' 0
function Get-NBTenantByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $TenantsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenantByName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBTenantGroupByID.ps1' 0
function Get-NBTenantGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $TenantGroupsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenantGroupByID.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBTenantGroupByName.ps1' 0
function Get-NBTenantGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $TenantGroupsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenantGroupByName.ps1' 10
#Region '.\Public\endpoints\tenancy\Get-NBTenantGroups.ps1' 0
function Get-NBTenantGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $TenantGroupsAPIPath

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenantGroups.ps1' 9
#Region '.\Public\endpoints\tenancy\Get-NBTenants.ps1' 0
function Get-NBTenants {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $TenantsAPIPath

}
#EndRegion '.\Public\endpoints\tenancy\Get-NBTenants.ps1' 9
#Region '.\Public\endpoints\tenancy\New-NBContact.ps1' 0
function New-NBContact {
	<#
	.SYNOPSIS
	Add new contact
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER group
	Group ID
	.PARAMETER title
	Title
	.PARAMETER phone
	Phone
	.PARAMETER email
	Email
	.PARAMETER address
	Address
	.PARAMETER link
	Link
	.PARAMETER comments
	Any comments you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][string]$title,
		[Parameter(Mandatory=$false)][string]$phone,
		[Parameter(Mandatory=$false)][string]$email,
		[Parameter(Mandatory=$false)][string]$address,
		[Parameter(Mandatory=$false)][string]$link,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\tenancy\New-NBContact.ps1' 50
#Region '.\Public\endpoints\tenancy\New-NBContactGroup.ps1' 0
function New-NBContactGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactGroupsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\tenancy\New-NBContactGroup.ps1' 21
#Region '.\Public\endpoints\tenancy\New-NBContactRole.ps1' 0
function New-NBContactRole {
	<#
	.SYNOPSIS
	Adds a new contact role to Netbox
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactRolesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\tenancy\New-NBContactRole.ps1' 33
#Region '.\Public\endpoints\tenancy\New-NBTenant.ps1' 0
function New-NBTenant {
	<#
	.SYNOPSIS
	Adds a new tenant to Netbox
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER group
	Group object ID
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER comments
	Any comments you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$TenantsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\tenancy\New-NBTenant.ps1' 38
#Region '.\Public\endpoints\tenancy\New-NBTenantGroup.ps1' 0
function New-NBTenantGroup {
	<#
	.SYNOPSIS
	Adds a new tenant group to Netbox
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER parent
	Parent object group ID
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$TenantGroupsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\tenancy\New-NBTenantGroup.ps1' 35
#Region '.\Public\endpoints\tenancy\Remove-NBContact.ps1' 0
function Remove-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Remove-NBContact.ps1' 15
#Region '.\Public\endpoints\tenancy\Remove-NBContactGroup.ps1' 0
function Remove-NBContactGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ContactGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Remove-NBContactGroup.ps1' 15
#Region '.\Public\endpoints\tenancy\Remove-NBContactRole.ps1' 0
function Remove-NBContactRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$ContactRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Remove-NBContactRole.ps1' 15
#Region '.\Public\endpoints\tenancy\Remove-NBTenant.ps1' 0
function Remove-NBTenant {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$TenantsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Remove-NBTenant.ps1' 15
#Region '.\Public\endpoints\tenancy\Remove-NBTenantGroup.ps1' 0
function Remove-NBTenantGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$TenantGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Remove-NBTenantGroup.ps1' 15
#Region '.\Public\endpoints\tenancy\Set-NBContact.ps1' 0
function Set-NBContact {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('group','name','title','phone','email','address',
			'link','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Set-NBContact.ps1' 27
#Region '.\Public\endpoints\tenancy\Set-NBContactGroup.ps1' 0
function Set-NBContactGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','group','description','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$ContactGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Set-NBContactGroup.ps1' 26
#Region '.\Public\endpoints\tenancy\Set-NBContactRole.ps1' 0
function Set-NBContactRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$ContactRolesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Set-NBContactRole.ps1' 26
#Region '.\Public\endpoints\tenancy\Set-NBTenant.ps1' 0
function Set-NBTenant {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','group','description','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$TenantsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Set-NBTenant.ps1' 26
#Region '.\Public\endpoints\tenancy\Set-NBTenantGroups.ps1' 0
function Set-NBTenantGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','parent','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$TenantGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\tenancy\Set-NBTenantGroups.ps1' 26
#Region '.\Public\endpoints\users\Get-NBUserByID.ps1' 0
function Get-NBUserByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $UsersAPIPath -id $id

}
#EndRegion '.\Public\endpoints\users\Get-NBUserByID.ps1' 10
#Region '.\Public\endpoints\users\Get-NBUserByName.ps1' 0
function Get-NBUserByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $UsersAPIPath -value $name

}
#EndRegion '.\Public\endpoints\users\Get-NBUserByName.ps1' 10
#Region '.\Public\endpoints\users\Get-NBUsers.ps1' 0
function Get-NBUsers {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $UsersAPIPath

}
#EndRegion '.\Public\endpoints\users\Get-NBUsers.ps1' 9
#Region '.\Public\endpoints\virtualization\Find-NBVMClusterGroupsContainingName.ps1' 0
function Find-NBVMClusterGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationClusterGroupsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\virtualization\Find-NBVMClusterGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\virtualization\Find-NBVMClustersContainingName.ps1' 0
function Find-NBVMClustersContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -name $name

}
#EndRegion '.\Public\endpoints\virtualization\Find-NBVMClustersContainingName.ps1' 10
#Region '.\Public\endpoints\virtualization\Find-NBVMClusterTypesContainingName.ps1' 0
function Find-NBVMClusterTypesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationClusterTypesAPIPath -name $name

}
#EndRegion '.\Public\endpoints\virtualization\Find-NBVMClusterTypesContainingName.ps1' 10
#Region '.\Public\endpoints\virtualization\Find-NBVMInterfacesContainingName.ps1' 0
function Find-NBVMInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -name $name

}
#EndRegion '.\Public\endpoints\virtualization\Find-NBVMInterfacesContainingName.ps1' 10
#Region '.\Public\endpoints\virtualization\Find-NBVMsContainingName.ps1' 0
function Find-NBVMsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -name $name

}
#EndRegion '.\Public\endpoints\virtualization\Find-NBVMsContainingName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMByID.ps1' 0
function Get-NBVMByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMByID.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMByName.ps1' 0
function Get-NBVMByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMByName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterByID.ps1' 0
function Get-NBVMClusterByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -id $id

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterByID.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterByName.ps1' 0
function Get-NBVMClusterByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -value $name

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterByName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterGroupByID.ps1' 0
function Get-NBVMClusterGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationClusterGroupsAPIPath -id $id

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterGroupByID.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterGroupByName.ps1' 0
function Get-NBVMClusterGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VirtualizationClusterGroupsAPIPath -value $name

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterGroupByName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterGroups.ps1' 0
function Get-NBVMClusterGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationClusterGroupsAPIPath

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterGroups.ps1' 9
#Region '.\Public\endpoints\virtualization\Get-NBVMClusters.ps1' 0
function Get-NBVMClusters {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusters.ps1' 9
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterTypeByID.ps1' 0
function Get-NBVMClusterTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationClusterTypesAPIPath -id $id

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterTypeByID.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterTypeByName.ps1' 0
function Get-NBVMClusterTypeByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VirtualizationClusterTypesAPIPath -value $name

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterTypeByName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMClusterTypes.ps1' 0
function Get-NBVMClusterTypes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationClusterTypesAPIPath

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMClusterTypes.ps1' 9
#Region '.\Public\endpoints\virtualization\Get-NBVMInterfaceByID.ps1' 0
function Get-NBVMInterfaceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -id $id

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMInterfaceByID.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMInterfaceByName.ps1' 0
function Get-NBVMInterfaceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -value $name

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMInterfaceByName.ps1' 10
#Region '.\Public\endpoints\virtualization\Get-NBVMInterfaces.ps1' 0
function Get-NBVMInterfaces {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMInterfaces.ps1' 9
#Region '.\Public\endpoints\virtualization\Get-NBVMs.ps1' 0
function Get-NBVMs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath

}
#EndRegion '.\Public\endpoints\virtualization\Get-NBVMs.ps1' 9
#Region '.\Public\endpoints\virtualization\New-NBVM.ps1' 0
function New-NBVM {
	<#
	.SYNOPSIS
	Adds a new virtual machine object to Netbox
	.PARAMETER name
	The name of the virtual machine 
	.PARAMETER cluster
	The ID of the vm cluster object
	.PARAMETER status
	The status of the new vm
	.PARAMETER role
	Role object ID
	.PARAMETER tenant
	Tenant object ID
	.PARAMETER platform 
	Platform object ID
	.PARAMETER primary_ip4
	IPv4 object ID
	.PARAMETER primary_ip6
	IPv6 object ID
	.PARAMETER vcpus
	Number of vCPUs assigned to this VM
	.PARAMETER memory
	Memory measured in MB
	.PARAMETER disk
	Disk space measured in GB
	.PARAMETER comments
	Any comments you would like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$cluster,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('offline','active','planned','staged','failed', 'decommissioning')]
		$status,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][int]$primary_ip4,
		[Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false)][int]$vcpus,
		[Parameter(Mandatory=$false)][int]$memory,
		[Parameter(Mandatory=$false)][int]$disk,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string]$local_context_data,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\virtualization\New-NBVM.ps1' 64
#Region '.\Public\endpoints\virtualization\New-NBVMCluster.ps1' 0
function New-NBVMCluster {
	<#
	.SYNOPSIS
	Creates a new virtual machine cluster object
	.PARAMETER name
	Name of the object
	.PARAMETER type
	ID of the type object
	.PARAMETER group
	ID of the group object
	.PARAMETER tenant
	ID of the tenant object
	.PARAMETER site
	ID of the site object
	.PARAMETER comments
	Any comments you would like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$type,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string]$status="active",
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	if (!($PSBoundParameters.ContainsKey('status'))) {$PSBoundParameters.add('status', $status)}
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClustersAPIPath/"
		body = $PostJson
	}
	$PostObject= Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\virtualization\New-NBVMCluster.ps1' 45
#Region '.\Public\endpoints\virtualization\New-NBVMClusterGroup.ps1' 0
function New-NBVMClusterGroup {
	<#
	.SYNOPSIS
	Add a new VM Cluster Group
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterGroupsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\virtualization\New-NBVMClusterGroup.ps1' 32
#Region '.\Public\endpoints\virtualization\New-NBVMClusterType.ps1' 0
function New-NBVMClusterType {
	<#
	.SYNOPSIS
	Add a new VM Cluster type
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\virtualization\New-NBVMClusterType.ps1' 33
#Region '.\Public\endpoints\virtualization\New-NBVMInterface.ps1' 0
function New-NBVMInterface {
	<#
	.SYNOPSIS
	Adds a new interface object to a VM
	.PARAMETER virtual_machine
	Virtual Machine object ID
	.PARAMETER name
	Name
	.PARAMETER enabled
	Is this interface enabled?
	.PARAMETER parent
	Parent interface ID
	.PARAMETER bridge
	Bridge object ID of this interface.
	.PARAMETER mtu
	 MTU of this interface
	.PARAMETER mac_address
	MAC address of this interface
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER mode
	Tagging mode of this interface.
	.PARAMETER untagged_vlan
	VLAN object ID
	.PARAMETER vrf
	VRF object ID
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$virtual_machine,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][bool]$enabled,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][int]$bridge,
		[Parameter(Mandatory=$false)][int]$mtu,
		[Parameter(Mandatory=$false)][string]$mac_address,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('access','tagged','tagged-all')]
		$mode,
		[Parameter(Mandatory=$false)][int]$untagged_vlan,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\virtualization\New-NBVMInterface.ps1' 60
#Region '.\Public\endpoints\virtualization\Remove-NBVM.ps1' 0
function Remove-NBVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Remove-NBVM.ps1' 15
#Region '.\Public\endpoints\virtualization\Remove-NBVMCluster.ps1' 0
function Remove-NBVMCluster {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClustersAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Remove-NBVMCluster.ps1' 15
#Region '.\Public\endpoints\virtualization\Remove-NBVMClusterGroup.ps1' 0
function Remove-NBVMClusterGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Remove-NBVMClusterGroup.ps1' 15
#Region '.\Public\endpoints\virtualization\Remove-NBVMClusterType.ps1' 0
function Remove-NBVMClusterType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Remove-NBVMClusterType.ps1' 15
#Region '.\Public\endpoints\virtualization\Remove-NBVMInterface.ps1' 0
function Remove-NBVMInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Remove-NBVMInterface.ps1' 15
#Region '.\Public\endpoints\virtualization\Set-NBVM.ps1' 0
function Set-NBVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','status','cluster','role','tenant','platform','primary_ipv4','primary_ipv6',
			'vcpus','memory','disk','comments','local_context_data')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Set-NBVM.ps1' 23
#Region '.\Public\endpoints\virtualization\Set-NBVMCluster.ps1' 0
function Set-NBVMCluster {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','type','group','tenant','site','comments')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClustersAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Set-NBVMCluster.ps1' 22
#Region '.\Public\endpoints\virtualization\Set-NBVMClusterGroup.ps1' 0
function Set-NBVMClusterGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Set-NBVMClusterGroup.ps1' 26
#Region '.\Public\endpoints\virtualization\Set-NBVMClusterType.ps1' 0
function Set-NBVMClusterType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	switch($key){
		'slug' {$value=makeSlug -name $value}
		default {}
	}
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypesAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Set-NBVMClusterType.ps1' 26
#Region '.\Public\endpoints\virtualization\Set-NBVMInterface.ps1' 0
function Set-NBVMInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('virtual_machine','name','enabled','parent','bridge','mtu','mac_address','description',
			'mode','untagged_vlan','vrf')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\virtualization\Set-NBVMInterface.ps1' 23
#Region '.\Public\endpoints\wireless\Find-NBWirelessLanGroupsContainingName.ps1' 0
function Find-NBWirelessLanGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -name $name

}
#EndRegion '.\Public\endpoints\wireless\Find-NBWirelessLanGroupsContainingName.ps1' 10
#Region '.\Public\endpoints\wireless\Get-NBWirelessLanByID.ps1' 0
function Get-NBWirelessLanByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath -id $id

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLanByID.ps1' 10
#Region '.\Public\endpoints\wireless\Get-NBWirelessLanBySSID.ps1' 0
function Get-NBWirelessLanBySSID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$SSID
	)
	Get-APIItemByQuery -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath -field ssid -value $SSID

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLanBySSID.ps1' 10
#Region '.\Public\endpoints\wireless\Get-NBWirelessLanGroupByID.ps1' 0
function Get-NBWirelessLanGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -id $id

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLanGroupByID.ps1' 10
#Region '.\Public\endpoints\wireless\Get-NBWirelessLanGroupByName.ps1' 0
function Get-NBWirelessLanGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -value $name

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLanGroupByName.ps1' 10
#Region '.\Public\endpoints\wireless\Get-NBWirelessLanGroups.ps1' 0
function Get-NBWirelessLanGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLanGroups.ps1' 9
#Region '.\Public\endpoints\wireless\Get-NBWirelessLans.ps1' 0
function Get-NBWirelessLans {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBWirelessLanAPIPath

}
#EndRegion '.\Public\endpoints\wireless\Get-NBWirelessLans.ps1' 9
#Region '.\Public\endpoints\wireless\New-NBWirelessLan.ps1' 0
function New-NBWirelessLan {
	<#
	.SYNOPSIS
	Adds a new wireless lan object to Netbox
	.PARAMETER ssid
	The SSID of the wireless LAN
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER group
	Group object ID
	.PARAMETER vlan
	VLAN object ID
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
#EndRegion '.\Public\endpoints\wireless\New-NBWirelessLan.ps1' 54
#Region '.\Public\endpoints\wireless\New-NBWirelessLanGroup.ps1' 0
function New-NBWirelessLanGroup {
	<#
	.SYNOPSIS
	Adds a new wireless lan group to Netbox
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER parent
	Parent object group ID
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}
#EndRegion '.\Public\endpoints\wireless\New-NBWirelessLanGroup.ps1' 35
#Region '.\Public\endpoints\wireless\Remove-NBWirelessLan.ps1' 0
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
#EndRegion '.\Public\endpoints\wireless\Remove-NBWirelessLan.ps1' 15
#Region '.\Public\endpoints\wireless\Remove-NBWirelessLanGroup.ps1' 0
function Remove-NBWirelessLanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\wireless\Remove-NBWirelessLanGroup.ps1' 15
#Region '.\Public\endpoints\wireless\Set-NBWirelessLan.ps1' 0
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
#EndRegion '.\Public\endpoints\wireless\Set-NBWirelessLan.ps1' 22
#Region '.\Public\endpoints\wireless\Set-NBWirelessLanGroup.ps1' 0
function Set-NBWirelessLanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','parent','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)

}
#EndRegion '.\Public\endpoints\wireless\Set-NBWirelessLanGroup.ps1' 22
#Region '.\Public\Get-NBCurrentConnection.ps1' 0
function Get-NBCurrentConnection {
	"Default Netbox Connection:"
	$Script:Connection
}
#EndRegion '.\Public\Get-NBCurrentConnection.ps1' 5
#Region '.\Public\New-NBConnection.ps1' 0
function New-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$DeviceAddress,
		[Parameter(Mandatory=$true,Position=1)][string]$ApiKey,
		[Parameter(Mandatory=$false)][string]$SkipCertificateCheck,
		[Parameter(Mandatory=$false)][switch]$Passthru
	)
	$ConnectionProperties = @{
		Address = "$DeviceAddress"
		ApiKey = $ApiKey
		ApiBaseUrl = "https://$($DeviceAddress)/api"
	}
	$Connection = New-Object psobject -Property $ConnectionProperties
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($Connection.Address)' is now the default connection."
	$Script:Connection = $Connection
	if ($Passthru) {
		$Connection
	}
}
#EndRegion '.\Public\New-NBConnection.ps1' 21
#Region '.\Public\Test-NBConnection.ps1' 0
function Test-NBConnection {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)][object]$NBConnection=$Script:Connection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to connect"
	try {
		"Connection OK`nNetbox Version: "+(Get-NBStatus -Connection $NBConnection)."netbox-version"
	}
	catch {
		write-error "failed"
		$NBConnection
	}
}
#EndRegion '.\Public\Test-NBConnection.ps1' 15
