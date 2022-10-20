$VirtualizationVMsAPIPath="virtualization/virtual-machines"
function New-NBVM {
	<#
	.SYNOPSIS
	Adds a new virtual machine object to Netbox
	.PARAMETER name
	The name of the virtual machine 
	.PARAMETER cluster
	The ID of the vm cluster where the object should be housed. Use `Get-NBVMClusterByName` to obtain this.
	.PARAMETER status
	The status of the new vm
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$cluster,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('offline','active','planned','staged','failed', 'decommissioning')]
		$status,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/"
		body = $PostJson
	}
	Write-Verbose $PostObject|ConvertTo-Json -Depth 50
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBVMs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath
}

function Get-NBVMByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -id $id
}

function Get-NBVMByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-APIItemByName -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -value $name
}

function Find-NBVMsContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationVMsAPIPath -name $name
}

function Set-NBVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('name','status','cluster','role','tenant','platform','primary_ipv4','primary_ipv6',
			'vcpus','memory','disk','comments','local_context_data')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBVM {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
