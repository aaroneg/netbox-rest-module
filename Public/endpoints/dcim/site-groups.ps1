# Enum NBSiteStatus {
# 	Planned = "planned"
# 	Staging = "staging"
# 	Active = "active"
# 	Decommissioning = "decommissioning"
# 	Retired = "retired"
# }
Class NBSiteGroup {
	[string]$name
	[string]$slug
	# Constructor
	NBSiteGroup(
		[string]$name
	){
		$this.name = $name
		$this.slug = makeSlug -name $name
	}
}
$SiteGroupsAPIPath="dcim/site-groups"

function New-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Site=[NBsiteGroup]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/"
		body = $Site|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Site|ConvertTo-Json -Depth 50
	$Site=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Site
}

function Get-NBSiteGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Set-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true)][int]$id,
		[Parameter(Mandatory=$true)][string]
			[ValidateSet('name','slug','description')]
			$key,
		[Parameter(Mandatory=$true)][string]$value
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

function Remove-NBSiteGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$SiteGroupsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}