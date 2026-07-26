<#
.SYNOPSIS
Create a new cable bundle object

.DESCRIPTION
Create a new cable bundle object

.PARAMETER name
The name of the bundle

.PARAMETER description
description

.PARAMETER owner
Owner object ID

.PARAMETER comments
comments

.PARAMETER tags
A list of tag ID[s]

.PARAMETER custom_fields
A hashtable of custom fields

.PARAMETER Connection
The connection object to use, if not using default.

.EXAMPLE
An example

.NOTES
General notes
#>
function New-NBCableBundle {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
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
		URI = "$($Connection.ApiBaseURL)/$NBCableBundlesAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}