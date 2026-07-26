<#
.SYNOPSIS
Create a new provider account

.DESCRIPTION
Create a new provider account

.PARAMETER provider
ID of the provider object

.PARAMETER name
The name of the account

.PARAMETER account
The account identifier

.PARAMETER description
Any description you'd like to provide

.PARAMETER comments
Any comments you'd like to provide

.PARAMETER tags
A list of tag IDs as an array

.PARAMETER custom_fields
A hash table of custom fields

.PARAMETER Connection
The connection object to use, if not using default.
#>
function New-NBCircuitProviderAccount {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=1)][int]$provider,	
		[Parameter(Mandatory=$false)][string]$name,
		[Parameter(Mandatory=$true,Position=0)][string]$account,
		[Parameter(Mandatory=$false)][string]$description,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][string[]]$tags,
		[Parameter(Mandatory=$false)][hashtable]$custom_fields,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$NBCircuitProviderAccountsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}