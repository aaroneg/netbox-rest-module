<#
.SYNOPSIS
Create power port object

.DESCRIPTION
Create power port object

.PARAMETER site
Object ID for site

.PARAMETER location
Object ID for location

.PARAMETER name
Name

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

.EXAMPLE
An example

.NOTES
General notes
#>
function New-NBPowerPort {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][int]$site,
		[Parameter(Mandatory=$false)][int]$location,
		[Parameter(Mandatory=$true,Position=1)][string]$name,
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
		URI = "$($Connection.ApiBaseURL)/$PowerPortAPIPath/"
		body = $PostJson
	}
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}