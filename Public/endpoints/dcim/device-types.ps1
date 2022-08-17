Class NBDeviceType {
	[int]$manufacturer
	[string]$model
	[string]$slug

	# Constructor
	NBDeviceType(
		[int]$manufacturer,
		[string]$model
	){
		$this.manufacturer = $manufacturer
		$this.model = $model
		$this.slug = makeSlug -name $model
	}
}
$deviceTypesPath="dcim/device-types"

function New-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$manufacturerID,
		[Parameter(Mandatory=$true,Position=1)][string]$model,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBDeviceType]::New($manufacturerID,$model)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBDeviceTypes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $deviceTypesPath
}

function Get-NBDeviceTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $deviceTypesPath -id $id
}
function Get-NBDeviceTypeByModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$model
	)
	Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ie' -value $model
}


function Find-NBDeviceTypesContainingModel {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$model
	)
	Get-ApiItemByQuery -apiConnection $Connection -RelativePath $deviceTypesPath -field 'model__ic' -value $model
}

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