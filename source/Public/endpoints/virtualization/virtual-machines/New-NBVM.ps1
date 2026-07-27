<#
.SYNOPSIS
Create a Virtual Machine

.DESCRIPTION
Create a Virtual Machine

.PARAMETER name
Description

.PARAMETER virtual_machine_type
Object ID for virtual machine type

.PARAMETER role
Object ID for 'device' role - must be a role that's been marked as eligible for virtual machines

.PARAMETER status
Lifecycle status of the VM, autocomplete enabled

.PARAMETER start_on_boot
$true if the vm is configured to start on boot

.PARAMETER site
Object ID for site - Required if you're not specifying a cluster

.PARAMETER cluster
Object ID for virtual machine cluster - Required if you're not specifying a site

.PARAMETER device
Object ID for device representing hypervisor

.PARAMETER platform
Object ID for device platform/OS

.PARAMETER vcpus
vCPU number - expressable a solid numbers or decimal ex: 1.5

.PARAMETER memory
Memory in MB

.PARAMETER disk
Disk in MB

.PARAMETER description
Description

.PARAMETER serial
Serial number

.PARAMETER tenant
Object ID for tenant

.PARAMETER owner
Object ID for owner

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER local_context_data
JSON string for local context data

.PARAMETER config_template
Object ID for config template

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBVM {
	[CmdletBinding(DefaultParameterSetName = 'Cluster')]
	[Alias('New-NBVirtualMachine')]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$virtual_machine_type,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateSet('offline','active','planned','staged','failed','decommissioning','paused')]
			[string]$status,
		[Parameter(Mandatory=$false)][bool]$start_on_boot,
		[Parameter(Mandatory=$false,ParameterSetName='Cluster')][Parameter(Mandatory=$true,ParameterSetName='Site')]
			[int]$site,
		[Parameter(Mandatory=$true,Position=2,ParameterSetName='Cluster')][Parameter(Mandatory=$false,Position=2,ParameterSetName='Site')]
			[int]$cluster,
		[Parameter(Mandatory=$false)][int]$device,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][double]$vcpus,
		[Parameter(Mandatory=$false)][int]$memory,
		[Parameter(Mandatory=$false)][int]$disk,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int[]]$tags,
		[Parameter(Mandatory=$false)][string]$local_context_data,
		[Parameter(Mandatory=$false)][string]$config_template,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
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