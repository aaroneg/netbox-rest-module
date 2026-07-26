<#
.SYNOPSIS
Create rack object

.DESCRIPTION
Create rack object

.PARAMETER name
Name

.PARAMETER facility_id
Facility identifier string

.PARAMETER site
Object ID for site

.PARAMETER location
Object ID for location

.PARAMETER tenant
Object ID for tenant

.PARAMETER status
Status, autocomplete enabled

.PARAMETER role
Object ID for role

.PARAMETER serial
Serial

.PARAMETER asset_tag
Asset tag

.PARAMETER rack_type
Object ID for rack type

.PARAMETER form_factor
Rack form factor

.PARAMETER width
Width

.PARAMETER u_height
Rack height in rack units

.PARAMETER starting_unit
Lowest numbered rack unit

.PARAMETER weight
Weight in whatever unit

.PARAMETER max_weight
Maximum weight in whatever unit

.PARAMETER weight_unit
g, kg, lb, oz

.PARAMETER desc_units
$true if the lowest numbered rack unit is at the top

.PARAMETER outer_width
Outside width

.PARAMETER outer_height
Outside height

.PARAMETER outer_depth
Outside depth

.PARAMETER outer_unit
mm, in

.PARAMETER mounting_depth
measured in mm

.PARAMETER airflow
Air flow direction, autocomplete enabled

.PARAMETER description
Description

.PARAMETER owner
Object ID for owner

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & IDs

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBRack {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$facility_id,
		[Parameter(Mandatory=$true,Position=1)][int]$site,
		[Parameter(Mandatory=$false)][int]$location,
		[Parameter(Mandatory=$true,Position=2)][int]$tenant,
		[Parameter(Mandatory=$false)]
			[ValidateSet('reserved','available','planned','active','deprecated')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$role,
		[Parameter(Mandatory=$false)][string]$serial,
		[Parameter(Mandatory=$false)][string]$asset_tag,
		[Parameter(Mandatory=$false)][int]$rack_type,
		[Parameter(Mandatory=$false)]
		[ValidateSet('2-post-frame','4-post-frame','4-post-cabinet','wall-frame','wall-frame-vertical','wall-cabinet','wall-cabinet-vertical')]
		[string]$form_factor,
		[Parameter(Mandatory=$false)][int]$width,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][int]$starting_unit,
		[Parameter(Mandatory=$false)][int]$weight,
		[Parameter(Mandatory=$false)][int]$max_weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		[Parameter(Mandatory=$false)][bool]$desc_units,
		[Parameter(Mandatory=$false)][int]$outer_width,
		[Parameter(Mandatory=$false)][int]$outer_height,
		[Parameter(Mandatory=$false)][int]$outer_depth,
		[Parameter(Mandatory=$false)]
			[ValidateSet('mm','in')]
			[string]$outer_unit,
		[Parameter(Mandatory=$false)][int]$mounting_depth,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front')]
			[string]$airflow,
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
		URI = "$($Connection.ApiBaseURL)/$RacksAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}