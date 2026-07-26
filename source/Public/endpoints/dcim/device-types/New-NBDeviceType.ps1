<#
.SYNOPSIS
Create device type

.DESCRIPTION
Create device type

.PARAMETER manufacturer
Object ID of the manufacturer

.PARAMETER default_platform
Object ID of the operating system

.PARAMETER model
Object ID of the model

.PARAMETER part_number
Part number

.PARAMETER u_height
Height in rack inutes

.PARAMETER exclude_from_utilization
$true if device should not be accounted for when calculating a rack's capacity

.PARAMETER is_full_depth
$true if device takes up the full depth of a rack unit

.PARAMETER subdevice_role
Either "Parent" or "Child" - leave undefined if this device cannot host other devices or be hosted by them.

.PARAMETER airflow
Airflow direction, autocomplete capable.

.PARAMETER weight
Number of weight units

.PARAMETER weight_unit
Definition for weight units, autocomplete capable.

.PARAMETER description
Description

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & IDs

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBDeviceType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$manufacturer,
		[Parameter(Mandatory=$false)][int]$default_platform,
		[Parameter(Mandatory=$true,Position=1)][string]$model,
		[Parameter(Mandatory=$false)][string]$part_number,
		[Parameter(Mandatory=$false)][int]$u_height,
		[Parameter(Mandatory=$false)][bool]$exclude_from_utilization,
		[Parameter(Mandatory=$false)][bool]$is_full_depth,
		[Parameter(Mandatory=$false)]
			[ValidateSet('parent','child')]
			[string]$subdevice_role,
		[Parameter(Mandatory=$false)]
			[ValidateSet('front-to-rear','rear-to-front','left-to-right','right-to-left','side-to-rear','rear-to-side','bottom-to-top','top-to-bottom','passive','mixed')]
			[string]$airflow,
		[Parameter(Mandatory=$false)][int]$weight,
		[Parameter(Mandatory=$false)]
			[ValidateSet('kg','g','lb','oz')]
			[string]$weight_unit,
		#[Parameter(Mandatory=$false)][string]$front_image,
		#[Parameter(Mandatory=$false)][string]$rear_image,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $model
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Running"
	Write-Verbose $PostJson
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$deviceTypesPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}