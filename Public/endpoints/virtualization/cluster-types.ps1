Class NBVMClusterType {
	[string]$name
	[string]$slug
	# Constructor
	NBVMClusterType(
		[string]$name
	){
		$this.name = $name
		$this.slug = makeSlug -name $name
	}
}
$VirtualizationClusterTypeAPIPath="virtualization/cluster-types"

function New-NBVMClusterType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$Contact=[NBVMClusterType]::New($name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypeAPIPath/"
		body = $Contact|ConvertTo-Json -Depth 50
	}
	Write-Verbose $Contact|ConvertTo-Json -Depth 50
	$Contact=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$Contact
}

function Get-NBVMClusterTypes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationClusterTypeAPIPath
}

function Get-NBVMClusterTypeByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationClusterTypeAPIPath -id $id
}

function Find-NBVMClusterTypesByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsByName -apiConnection $Connection -RelativePath $VirtualizationClusterTypeAPIPath -name $name
}

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
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypeAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBVMClusterType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationClusterTypeAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}