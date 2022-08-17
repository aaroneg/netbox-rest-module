Class NBContactGroup {
	[string]$name
	[string]$slug
	# Constructor
	NBContactGroup(
		[string]$name
	){
		$this.name = $name
		$this.slug = makeSlug -name $name
	}
}
$ContactGroupsAPIPath="tenancy/contact-groups"

function New-NBContactGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBContactGroup]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactGroupsAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBContactGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $ContactGroupsAPIPath
}

function Get-NBContactGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -id $id
}
function Get-NBContactGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -value $name
}
function Find-NBContactGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $ContactGroupsAPIPath -name $name
}

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