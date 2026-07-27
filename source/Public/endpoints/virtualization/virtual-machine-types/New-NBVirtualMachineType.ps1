<#
.SYNOPSIS
Creates a new virtual machine type

.DESCRIPTION
Creates a new virtual machine type, a sort of template for a collection of settings for a customer-defined type of vm. Includes default resource totals, descriptions, owners, etc

.PARAMETER name
Name

.PARAMETER default_platform
Object ID of a default platform/os

.PARAMETER default_vcpus
A default value for CPUs, expressable as an integer or decimal - ex: 1.5

.PARAMETER default_memory
Default memory value in MB

.PARAMETER description
Description

.PARAMETER owner
Object ID of owner

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
An example

.NOTES
General notes
#>
function New-NBVirtualMachineType {
	[CmdletBinding(DefaultParameterSetName = 'Cluster')]
	[Alias('New-NBVirtualMachine')]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$default_platform,
		[Parameter(Mandatory=$false)][double]$default_vcpus,
		[Parameter(Mandatory=$false)][int]$default_memory,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$VirtualizationVMTypesAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}