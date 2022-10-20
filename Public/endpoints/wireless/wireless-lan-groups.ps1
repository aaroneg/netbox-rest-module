$NBWirelessLanGroupAPIPath="wireless/wireless-lan-groups"
function New-NBWirelessLanGroup {
	<#
	.SYNOPSIS
	Adds a new wireless lan group to Netbox
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER parent
	Parent object group ID
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/"
		body = $PostJson
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBWirelessLanGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath
}

function Get-NBWirelessLanGroupByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -id $id
}

function Get-NBWirelessLanGroupByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -value $name
}


function Find-NBWirelessLanGroupsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $NBWirelessLanGroupAPIPath -name $name
}

function Set-NBWirelessLanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','slug','parent','description')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBWirelessLanGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$NBWirelessLanGroupAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
