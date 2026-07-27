<#
.SYNOPSIS
Create region object

.DESCRIPTION
Create region object

.PARAMETER name
Name

.PARAMETER parent
Object ID for parent region object, if needed

.PARAMETER description
Description

.PARAMETER tags
Array of tag IDs

.PARAMETER custom_fields
A hashtable of custom fields & values

.PARAMETER owner
Object ID of owner

.PARAMETER comments
Comments

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBRegion {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$parent,
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
		URI = "$($Connection.ApiBaseURL)/$regionsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}