<#
.SYNOPSIS
Create device bay

.DESCRIPTION
Create device bay

.PARAMETER device
Device object id

.PARAMETER name
Name

.PARAMETER label
Label

.PARAMETER enabled
Boolean - $true or $false

.PARAMETER description
Description

.PARAMETER installed_device
The device ID that is installed in this device bay

.PARAMETER owner
Owner object ID

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & IDs

.PARAMETER Connection
The connection object to use, if not using default.

.NOTES
The device type for the device you try to add a bay to must already be set as a 'parent' device instead of null or child
#>
function New-NBDeviceBay {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$device,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)][bool]$enabled,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$installed_device,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBDeviceBaysAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}