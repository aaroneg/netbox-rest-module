function New-NBVM {
	<#
	.SYNOPSIS
	Adds a new virtual machine object to Netbox
	.PARAMETER name
	The name of the virtual machine 
	.PARAMETER cluster
	The ID of the vm cluster object
	.PARAMETER status
	The status of the new vm
	.PARAMETER role
	Role object ID
	.PARAMETER tenant
	Tenant object ID
	.PARAMETER platform 
	Platform object ID
	.PARAMETER primary_ip4
	IPv4 object ID
	.PARAMETER primary_ip6
	IPv6 object ID
	.PARAMETER vcpus
	Number of vCPUs assigned to this VM
	.PARAMETER memory
	Memory measured in MB
	.PARAMETER disk
	Disk space measured in GB
	.PARAMETER comments
	Any comments you would like to add
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
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][int]$primary_ip4,
		[Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false)][int]$vcpus,
		[Parameter(Mandatory=$false)][int]$memory,
		[Parameter(Mandatory=$false)][int]$disk,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string]$local_context_data,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}