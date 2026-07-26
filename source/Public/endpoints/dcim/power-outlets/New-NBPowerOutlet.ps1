<#
.SYNOPSIS
Create Power Outlet

.DESCRIPTION
Create Power Outlet

.PARAMETER device
Object ID of parent device

.PARAMETER module
Object ID of module

.PARAMETER name
Name of object, as specified by the OS or management system

.PARAMETER label
Physical label on outlet

.PARAMETER type
Type of outlet

.PARAMETER status
Operational status of port - autocomplete enabled

.PARAMETER color
Hex code, do not prefix with '#'. ex: FFFFFF

.PARAMETER power_port
Power port object ID

.PARAMETER feed_leg
a, b, or c

.PARAMETER description
Description

.PARAMETER mark_connected
Treat outlet as connected

.PARAMETER owner
Owner object ID

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & IDs

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBPowerOutlet {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$device,
		[Parameter(Mandatory=$false)][int]$module,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
		[Parameter(Mandatory=$false)][string]$label,
		[Parameter(Mandatory=$false)]
			# Not going to enumerate every possible value here, there are too many.
			[string]$type,
		[Parameter(Mandatory=$false)]
			[ValidateSet('enabled','disabled','faulty')]
			[string]$status,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][hashtable]$power_port,
		[Parameter(Mandatory=$false)]
			[ValidateSet('A','B','C')]
			[string]$feed_leg,
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
		URI = "$($Connection.ApiBaseURL)/$NBPowerOutletsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}