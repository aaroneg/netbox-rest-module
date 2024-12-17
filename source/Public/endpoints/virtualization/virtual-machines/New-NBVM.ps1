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
	[CmdletBinding(DefaultParameterSetName = 'Cluster')]
	param (
		[Parameter(Mandatory=$true,Position=0,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$true,Position=0,ParameterSetName='Site')]
			[string]$name,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[ValidateSet('offline','active','planned','staged','failed', 'decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$true,ParameterSetName='Site')]
			[int]$site,
		[Parameter(Mandatory=$true,Position=1,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,Position=1,ParameterSetName='Site')]
			[int]$cluster,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$device,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string]$serial,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$role,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$tenant,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$platform,
		# Genuinely don't understand why the form asks for this on a new vm, not like there's an IP already associated
		# that you could assign as primary
		# [Parameter(Mandatory=$false)][int]$primary_ip4,
		# [Parameter(Mandatory=$false)][int]$primary_ip6,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[double]$vcpus,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$memory,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[int]$disk,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string]$description,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string]$comments,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string]$config_template,			
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string]$local_context_data,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[string[]]$tags,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[hashtable]$custom_fields,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')]
		[Parameter(Mandatory=$false,ParameterSetName='Site')]
			[object]$Connection=$Script:Connection
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