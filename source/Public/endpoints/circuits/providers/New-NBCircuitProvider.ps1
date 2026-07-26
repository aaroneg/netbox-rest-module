<#
.SYNOPSIS
Create a circuit provider object

.DESCRIPTION
Create a circuit provider object

.PARAMETER name
The name of the circuit provider

.PARAMETER description
Any description you'd like to provide

.PARAMETER comments
Any comments you'd like to provide

.PARAMETER asns
A list of ASN object ID[s]

.PARAMETER tags
A list of tag object ID[s]

.PARAMETER custom_fields
A hashtable of the custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCircuitProvider {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		# Not adding support for accounts here, you can set those on the account
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$asns,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PSBoundParameters['slug']=makeSlug -name $name
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProvidersAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}