Class NBLocation {
	[string]$name
	[int]$site
	[int]$location
	[string]$status
	# Constructor
	NBLocation(
		[string]$name,
		[int]$site,
		[int]$location,
		[string]$status
	){
		$this.site = $site
		$this.name = $name
		$this.location = $location
		$this.status = $status
	}
}
$LocationsAPIPath="dcim/locations"

function New-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=0)][int]$site,
		[Parameter(Mandatory=$true,Position=0)][int]$location,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Location=[NBLocation]::New($name,$site)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/"
		body = $Location|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Location|ConvertTo-Json -Depth 50
	$Location=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Location
}

function Get-NBLocations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $LocationsAPIPath
}

function Get-NBLocationByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $LocationsAPIPath -id $id
}


function Find-NBLocationsByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsByName -apiConnection $Connection -RelativePath $LocationsAPIPath -name $name
}

function Set-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','location','site','region','group','tenant','facility','time_zone','description','physical_address','shipping_address','latitude','longitude','comments')]
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