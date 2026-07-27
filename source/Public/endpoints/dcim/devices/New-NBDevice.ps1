<#
.SYNOPSIS
Create a new Device object

.DESCRIPTION
Create a new Device object

.PARAMETER name
Device name

.PARAMETER device_type
Device type object ID

.PARAMETER role
Role object ID

.PARAMETER tenant
Tenant object ID

.PARAMETER platform
Platform object ID

.PARAMETER serial
Serial number

.PARAMETER asset_tag
Asset tag

.PARAMETER site
Site object ID

.PARAMETER location
Location object ID

.PARAMETER rack
Rack object ID

.PARAMETER position
Lowest rack unit number occupied by the device

.PARAMETER face
'front' or 'rear'

.PARAMETER latitude
xx.yyyy

.PARAMETER longitude
xx.yyyy

.PARAMETER status
Lifecycle status, autocomplete enabled

.PARAMETER airflow
Airflow, autocomplete enabled

.PARAMETER cluster
Cluster object ID

.PARAMETER virtual_chassis
Virtual chassis object ID

.PARAMETER vc_position
Virtual chassis position number

.PARAMETER vc_priority
Virtual chassis priority number

.PARAMETER description
Description

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER config_template
Config template object ID

.PARAMETER local_context_data
Local context data JSON

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBDevice {
	[CmdletBinding()]
	# ValidateSets updated as of Netbox v4.1.8
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$device_type,
		[Parameter(Mandatory=$true,Position=2)][int]$role,
		[Parameter(Mandatory=$false,Position=3)][int]$tenant,
		[Parameter(Mandatory=$false)][int]$platform,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][string]$asset_tag,
		[Parameter(Mandatory=$false)][int]$site,
		[Parameter(Mandatory=$false)][int]$location,
		[Parameter(Mandatory=$false)][int]$rack,
		[Parameter(Mandatory=$false)][int]$position,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front','rear')]
			[string]$face,
		[Parameter(Mandatory=$false)][double]$latitude,
		[Parameter(Mandatory=$false)][double]$longitude,
		[Parameter(Mandatory=$false)]
			[ValidateSet('offline','active','planned','staged','failed','inventory','decommissioning')]
			[string]$status,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','rear-to-side','bottom-to-top','top-to-bottom','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$cluster,
		[Parameter(Mandatory=$false)][int]$virtual_chassis,
		[Parameter(Mandatory=$false)][int]$vc_position,
		[Parameter(Mandatory=$false)][int]$vc_priority,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int]$config_template,
		[Parameter(Mandatory=$false)][int]$local_context_data,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$DevicesAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}