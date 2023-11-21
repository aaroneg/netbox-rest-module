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
	.PARAMETER site
	The ID of the site for the object
	.PARAMETER device
	The ID of a device in the cluster this object is pinned to
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
	.PARAMETER description
	A description of the object.
	.PARAMETER comments
	Any comments you would like to add
	.PARAMETER local_context_data
	A json string with local context data for the object.
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false,Position=1)][int]$cluster,
		[Parameter(Mandatory=$false)][string]
		[ValidateSet('offline','active','planned','staged','failed', 'decommissioning')]
		$status,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$device,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		# Genuinely don't understand why the form asks for this on a new vm, not like there's an IP already associated
		# that you could assign as primary
		# [Parameter(Mandatory=$false)][int]$primary_ip4,
		# [Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false)][double]$vcpus,
		[Parameter(Mandatory=$false)][int]$memory,
		[Parameter(Mandatory=$false)][int]$disk,
		[Parameter(Mandatory=$false)][string]$description,
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