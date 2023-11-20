function New-NBContact {
	<#
	.SYNOPSIS
	Add new contact
	.PARAMETER name
	This parameter will be used both directly and to create an appropriate slug.
	.PARAMETER group
	Group ID
	.PARAMETER title
	Title
	.PARAMETER phone
	Phone
	.PARAMETER email
	Email
	.PARAMETER address
	Address
	.PARAMETER link
	Link
	.PARAMETER comments
	Any comments you'd like to add
	.PARAMETER Connection
	Connection object to use
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$name,
		[Parameter(Mandatory=$false)][int]$group,
		[Parameter(Mandatory=$false)][string]$title,
		[Parameter(Mandatory=$false)][string]$phone,
		[Parameter(Mandatory=$false)][string]$email,
		[Parameter(Mandatory=$false)][string]$address,
		[Parameter(Mandatory=$false)][string]$link,
		[Parameter(Mandatory=$false)][string]$comments,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:Connection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())
	$restParams=@{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$ContactsAPIPath/"
		body = $PostJson
	}
	
	$PostObject=Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if ($PostObject.message) {
		throw $PostObject.message
	}
	$PostObject

}