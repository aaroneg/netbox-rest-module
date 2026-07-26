<#
.SYNOPSIS
Create circuit provider network

.DESCRIPTION
Create circuit provider network

.PARAMETER provider
The provider object ID

.PARAMETER name
The name of the network

.PARAMETER service_id
The provider-supplied service ID

.PARAMETER description
A description of the object

.PARAMETER owner
Object ID for the owner

.PARAMETER comments
Any comments you have about the object

.PARAMETER tags
A list of tag IDs as an array

.PARAMETER custom_fields
A hash table of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCircuitProviderNetwork {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=1)][int]$provider,
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][string]$service_id,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$owner,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProviderNetworksAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}