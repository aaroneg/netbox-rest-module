<#
.SYNOPSIS
Create MAC address object

.DESCRIPTION
Create MAC address object

.PARAMETER mac_address
MAC address

.PARAMETER assigned_object_type
Type of interface, autocomplete enabled

.PARAMETER assigned_object_id
Object ID of interface

.PARAMETER description
Description

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBMacAddress {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$mac_address,
		[Parameter(Mandatory=$true,Position=1)][ValidateSet('dcim.interface','virtualization.vminterface')][int]$assigned_object_type,
		[Parameter(Mandatory=$true,Position=2)][int]$assigned_object_id,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$MACAddressAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}