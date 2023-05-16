$VirtualizationClustersAPIPath="virtualization/clusters"

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
		[Parameter(Mandatory=$false)][int]$comments,
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
	$PostObject
}

function Get-NBVMClusters {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath
}

function Get-NBVMClusterByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -id $id
}

function Get-NBVMClusterByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -value $name
}

function Find-NBVMClustersContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationClustersAPIPath -name $name
}

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

Export-ModuleMember -Function "*-*"
