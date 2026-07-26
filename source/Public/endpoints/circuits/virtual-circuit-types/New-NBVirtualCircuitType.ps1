<#
.SYNOPSIS
New virtual circuit type

.DESCRIPTION
New virtual circuit type

.PARAMETER name
Name of circuit type

.PARAMETER color
Hex color code, do not prefix with `#`

.PARAMETER description
A description

.PARAMETER owner
An owner object ID

.PARAMETER comments
commects

.PARAMETER tags
list of tag ID[s]

.PARAMETER custom_fields
hashtable of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBVirtualCircuitType {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$color,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][int]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBVirtualCircuitTypessAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}