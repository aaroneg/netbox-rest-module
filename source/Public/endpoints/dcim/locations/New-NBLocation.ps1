<#
.SYNOPSIS
Create location object

.DESCRIPTION
Create location object

.PARAMETER name
Name

.PARAMETER site
Site object ID

.PARAMETER parent
Parent object ID

.PARAMETER status
Lifecycle status, autocomplete enabled

.PARAMETER tenant
Tenant object ID

.PARAMETER facility
A text facility name, if provided by a hosting provider/datacenter.

.PARAMETER description
Description

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER owner
Owner object ID

.PARAMETER comments
Comments

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBLocation {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$true,Position=1)][int]$site,
		[Parameter(Mandatory=$false)][int]$parent,
		[Parameter(Mandatory=$false)]
			[ValidateSet('planned','staging','active','decommissioning','retired')]
			[string]$status,
		[Parameter(Mandatory=$false)][int]$tenant,
		[Parameter(Mandatory=$false)][string]$facility,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$LocationsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}