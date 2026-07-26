<#
.SYNOPSIS
New circuit type object

.DESCRIPTION
New circuit type object

.PARAMETER name
Name of the object

.PARAMETER color
A color expressed as a hex code - digits only, no `#` character

.PARAMETER description
description

.PARAMETER tags
tag[s]

.PARAMETER custom_fields
Hashtable of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCircuitType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitTypesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}