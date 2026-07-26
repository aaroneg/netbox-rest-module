<#
.SYNOPSIS
Create a new site object

.DESCRIPTION
Create a new site object

.PARAMETER name
Name

.PARAMETER status
Lifecycle status, autocomplete enabled

.PARAMETER region
Object ID for region

.PARAMETER group
Object ID for site group

.PARAMETER tenant
Object ID for tenant

.PARAMETER facility
Facility name / description

.PARAMETER time_zone
Time Zone ex: Africa/Abidjan

.PARAMETER description
Description

.PARAMETER physical_address
Physical address

.PARAMETER shipping_address
Address for shipping

.PARAMETER latitude
Latitude

.PARAMETER longitude
Longitude

.PARAMETER owner
Object ID of Owner

.PARAMETER comments
Comments

.PARAMETER asns
Array of ASN object IDs

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
Parameter description

.PARAMETER Connection
A hashtable of custom fields & IDs
#>
function New-NBSite {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][string]
			[ValidateSet('planned','staging','active','decommissioning','retired')]
			$status,
		[Parameter(Mandatory=$false)][int]$region,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$facility,
		[Parameter(Mandatory=$false)][string]$time_zone,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$physical_address,
		[Parameter(Mandatory=$false)][string]$shipping_address,
		[Parameter(Mandatory=$false)][double]$latitude,
		[Parameter(Mandatory=$false)][double]$longitude,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][int[]]$asns,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$SitesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}