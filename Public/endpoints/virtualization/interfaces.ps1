$VirtualizationInterfaceAPIPath="virtualization/interfaces"

function New-NBVMInterface {
	<#
	.SYNOPSIS
	Adds a new interface object to a VM
	.PARAMETER virtual_machine
	Virtual Machine object ID
	.PARAMETER name
	Name
	.PARAMETER enabled
	Is this interface enabled?
	.PARAMETER parent
	Parent interface ID
	.PARAMETER bridge
	Bridge object ID of this interface.
	.PARAMETER mtu
	 MTU of this interface
	.PARAMETER mac_address
	MAC address of this interface
	.PARAMETER description
	Any description you'd like to add
	.PARAMETER mode
	Tagging mode of this interface.
	.PARAMETER untagged_vlan
	VLAN object ID
	.PARAMETER vrf
	VRF object ID
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$virtual_machine,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][bool]$enabled,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)][int]$bridge,
		[Parameter(Mandatory=$false)][int]$mtu,
		[Parameter(Mandatory=$false)][string]$mac_address,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('access','tagged','tagged-all')]
		$mode,
		[Parameter(Mandatory=$false)][int]$untagged_vlan,
		[Parameter(Mandatory=$false)][int]$vrf,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostObject=[NBVMInterface]::New($VMID,$name)
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/"
		body = $PostObject|ConvertTo-Json -Depth 50
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

function Get-NBVMInterfaces {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	Get-ApiItems -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath
}

function Get-NBVMInterfaceByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	Get-ApiItemByID -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -id $id
}

function Get-NBVMInterfaceByName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][string]$name
	)
	Get-ApiItemByName -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -value $name
}

function Find-NBVMInterfacesContainingName {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=1)][string]$name
	)
	Find-ApiItemsContainingName -apiConnection $Connection -RelativePath $VirtualizationInterfaceAPIPath -name $name
}

function Set-NBVMInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('virtual_machine','name','enabled','parent','bridge','mtu','mac_address','description',
			'mode','untagged_vlan','vrf')]
			$key,
		[Parameter(Mandatory=$true,Position=2)][string]$value
	)
	$update=@{
		$key = $value
	}
	$restParams=@{
		Method = 'Patch'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

function Remove-NBVMInterface {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection,
		[Parameter(Mandatory=$true,Position=0)][int]$id
	)
	$restParams=@{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/$id/"
		body = $update | ConvertTo-Json -Depth 50
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection)
}

Export-ModuleMember -Function "*-*"
