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
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationInterfaceAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}