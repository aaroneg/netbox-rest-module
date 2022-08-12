Class NBSite {
	[string]$name
	[string]$status
	[string]$slug
	# Constructor
	NBSite(
		[string]$name,
		[string]$status
	){
		$this.status = $status.ToLower()
		$this.name = $name
		$this.slug = makeSlug -name $name
	}
}
$SitesAPIPath="dcim/sites"

function New-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]$status,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Site=[NBsite]::New($name,$status)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/"
		body = $Site|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Site|ConvertTo-Json -Depth 50
	$Site=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Site
}

function Get-NBSites {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/"
	}
	$restParams.URI
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

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