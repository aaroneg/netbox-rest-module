<#
.SYNOPSIS
Create rack reservation

.DESCRIPTION
Long description

.PARAMETER rack
Object ID for rack

.PARAMETER units
Size of reservation, in rack units

.PARAMETER status
pending, active, or stale

.PARAMETER user
Object ID for user

.PARAMETER tenant
Object ID for tenant

.PARAMETER description
Description

.PARAMETER owner
Object ID for owner

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBRackReservation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$rack,
		[Parameter(Mandatory=$true,Position=1)]
			[ValidateRange(0,32767)]
			[int]$units,
		[Parameter(Mandatory=$false)][ValidateSet('pending','active','stale')][string]$status,
		[Parameter(Mandatory=$true,Position=3)][int]$user,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$true,Position=4)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][int]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$RackReservationsAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}