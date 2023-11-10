$RacksAPIPath="dcim/racks"

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

function Get-NBRacks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $RacksAPIPath
}

function Get-NBRackByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $RacksAPIPath -id $id
}

function Get-NBRackByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $RacksAPIPath -value $name
}

function Find-NBRacksContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $RacksAPIPath -name $name
}

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

Export-ModuleMember -Function "*-*"
