Class NBRackRole {
	[string]$name
	[string]$slug
	# Constructor
	NBRackRole(
		[string]$name
	){
		$this.name = $name
		$this.slug = makeSlug -name $name
	}
}
$RackRolesAPIPath="dcim/rack-roles"

function New-NBRackRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$RackRole=[NBRackRole]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/"
		body = $RackRole|ConvertTo-Json -Depth 50
	}
	Write-Verbose $RackRole|ConvertTo-Json -Depth 50
	$RackRole=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$RackRole
}

function Get-NBRackRoles {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/"
	}
	$restParams.URI
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).results
}

function Get-NBRackRole {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$RackRolesAPIPath/$id/"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

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