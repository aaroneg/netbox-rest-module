<#
.SYNOPSIS
Create a new console port object

.DESCRIPTION
Create a new console port object

.PARAMETER device
Device object ID

.PARAMETER module
Module object ID

.PARAMETER name
Name as referenced by the operating system, ex: con0

.PARAMETER label
Physical label on the port, ex: 0

.PARAMETER type
Connection type. API value is usually a lowercase version of the values visible in the web interface, with spaces replaced by dashes.

.PARAMETER speed
Speed, in bytes. Constricted to a known set of values, defined in cmdlet

.PARAMETER description
Description of object

.PARAMETER mark_connected
Treat this port as connected.

.PARAMETER owner
Object ID of the owner

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & IDs

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBConsolePort {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$device,
		[Parameter(Mandatory=$false)][int]$module,
		[Parameter(Mandatory=$true,Position=2)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)][string]$type,
		[Parameter(Mandatory=$false)][int][ValidateSet(1200,2400,4800,9600,19200,38400,57600,115200)]$speed,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][bool]$mark_connected,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBConsolePortsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}