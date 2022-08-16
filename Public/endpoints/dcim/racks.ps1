Class NBRack {
	[string]$name
	[int]$site
	[int]$location
	# Constructor
	NBRack(
		[string]$name,
		[int]$site,
		[int]$location
	){
		$this.site = $site
		$this.name = $name
		$this.location = $location
	}
}
$RacksAPIPath="dcim/racks"

function New-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$site,
		[Parameter(Mandatory=$true,Position=2)][int]$location,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Rack=[NBRack]::New($name,$site,$location)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/"
		body = $Rack|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Rack|ConvertTo-Json -Depth 50
	$Rack=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Rack
}

function Get-NBRacks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Set-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','facility_id','site','location','tenant','status',
			'role','serial','asset_tag','type','width','u_height','desc_units','outer_width',
			'outer_depth','outer_unit','comments')]
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